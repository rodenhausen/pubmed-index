package edu.arizona.sista.pubmedindex

import scala.io.Source
import java.io.File
import scala.collection.JavaConverters._
import java.util.Properties
import java.sql.DriverManager
import java.sql.Connection
import edu.arizona.sista.pubmedindex.MyXML
import java.sql.PreparedStatement
import java.sql.Statement
import java.lang.Exception

object Main {
  
  def recursiveListFiles(file: File): Array[File] = {
    val files = file.listFiles.filter(_.isFile());
    files ++ file.listFiles.filter(_.isDirectory).flatMap(recursiveListFiles)
  }
  
  def intOrElse(text: String): Int = { 
	 try {
		 Integer.valueOf(text)
	 } catch {
	   case e:Exception => -1
	 }
  }
  
  
  def storePMCContent(file: File, connection: Connection) { 
    println(file.getAbsolutePath())
    val article = MyXML.loadFile(file);

    val pmcidText = (article \ "front" \ "article-meta" \ "article-id").filter({ _ \ "@pub-id-type" exists (_.text == "pmc") }).text
    val pmcid = intOrElse(pmcidText)
    val pmidText = (article \ "front" \ "article-meta" \ "article-id").filter({ _ \ "@pub-id-type" exists (_.text == "pmid") }).text
    val pmid = intOrElse(pmidText)
    val source = "us"
    val publication_source: String = null
    val journal = (article \ "front" \ "journal-meta" \ "journal-title-group" \ "journal-title").text
    val title = (article \ "front" \ "article-meta" \ "title-group" \ "article-title").text
    val abstractText = (article \ "front" \ "article-meta" \ "abstract").text  
    val body = "" //(article \ "body").text
    val oa = true
    
    val licenseName = (article \ "front" \ "article-meta" \ "permissions" \ "license" \ "@license-type").text 
    val licenseText = (article \ "front" \ "article-meta" \ "permissions"  \ "license").text

    var license: String = null
    if(!licenseName.isEmpty()) {
    	val licenseInsert = new Query(connection, true, "INSERT IGNORE INTO license (name) VALUES(?)")
	    licenseInsert.setParameter(1, licenseName)
	    licenseInsert.executeAndClose    	
	    license = licenseName
    }

    val import_source = file.getParentFile.getName + File.separator + file.getName
    /*println(pmid)
    println(pmcid)
    println(journal)
    println(title)
    println(abstractText)
    println(license)
    */
    
    val journalInsert = new Query(connection, true, 
        "INSERT IGNORE INTO journal (name) VALUES (?)")
    journalInsert.setParameter(1, journal)
    journalInsert.executeAndClose
        
    try {
	    val paperInsert = new Query(connection, true, 
	    			"INSERT INTO paper (pmcid, pmid, source, publication_source, journal, title, abstract, body, oa, license, import_source) " + 
	    			"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
	    paperInsert.setParameter(1, pmcid)
	    paperInsert.setParameter(2, pmid)
	    paperInsert.setParameter(3, source)
	    paperInsert.setParameter(4, publication_source)
	    paperInsert.setParameter(5, journal)
	    paperInsert.setParameter(6, title)
	    paperInsert.setParameter(7, abstractText)
	    paperInsert.setParameter(8, body)
	    paperInsert.setParameter(9, oa)
	    paperInsert.setParameter(10, license)
	    paperInsert.setParameter(11, import_source)
	    paperInsert.executeAndClose
		
		
		if(!licenseName.isEmpty()) {
		  	val licenseTextInsert = new Query(connection, true, "INSERT IGNORE INTO license_text (pmcid, pmid, source, text, license) VALUES(?, ?, ?, ?, ?)")
		    licenseTextInsert.setParameter(1, pmcid)
		    licenseTextInsert.setParameter(2, pmid)
		    licenseTextInsert.setParameter(3, source)
		    licenseTextInsert.setParameter(4, licenseText)
		    licenseTextInsert.setParameter(5, licenseName)
		    licenseTextInsert.executeAndClose
	  	}
    
	    val keywords = (article \ "front" \ "article-meta" \ "kwd-group" \ "kwd").map(x => x.text)
	    //println(keywords)
	    
	    keywords.foreach(k => { 
          val keywordInsert = new Query(connection, true, 
    			"INSERT IGNORE INTO keyword (name) VALUES(?)")
          keywordInsert.setParameter(1, k)
          keywordInsert.executeAndClose
          
          val paperKeywordInsert = new Query(connection, true, 
    			"INSERT IGNORE INTO paper_keyword (pmcid, pmid, source, keyword) VALUES(?, ?, ? , ?)")
          paperKeywordInsert.setParameter(1, pmcid)
          paperKeywordInsert.setParameter(2, pmid)
          paperKeywordInsert.setParameter(3, source)
          paperKeywordInsert.setParameter(4, k)
          paperKeywordInsert.executeAndClose
	    })
	    
  	} catch {
  	  case e:Exception => e.printStackTrace()
  	  println(import_source)
  	}
    
  	
  }
  
  
  
  def main(args: Array[String]): Unit = {
    val loader = Thread.currentThread().getContextClassLoader();
    val config = new Properties
    config.load(loader.getResourceAsStream("config.properties"));

    val databaseName = config.getProperty("databaseName")
	val	databaseUser = config.getProperty("databaseUser")
	val	databasePassword = config.getProperty("databasePassword")
	val	databaseHost = config.getProperty("databaseHost")
	val	databasePort = config.getProperty("databasePort")
	
	val pmcArticlesRoot = config.getProperty("pmcArticlesRoot")
	
	val jdbcUrl = "jdbc:mysql://" + databaseHost + ":" + databasePort + "/" + databaseName + "?connecttimeout=0&sockettimeout=0&autoreconnect=true";
	Class.forName("com.mysql.jdbc.Driver");
	val connection = DriverManager.getConnection(jdbcUrl, databaseUser, databasePassword);
	
    val sourceFiles = recursiveListFiles(new File(pmcArticlesRoot))
    sourceFiles.foreach(storePMCContent(_, connection))
    
    connection.close();
  }

}