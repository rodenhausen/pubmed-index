package edu.arizona.sista.pubmedindex

import scala.xml.Elem
import scala.xml.factory.XMLLoader
import javax.xml.parsers.SAXParser

object MyXML extends XMLLoader[Elem] {
  override def parser: SAXParser = {
    val f = javax.xml.parsers.SAXParserFactory.newInstance()
    f.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false)
    f.newSAXParser()
  }
}