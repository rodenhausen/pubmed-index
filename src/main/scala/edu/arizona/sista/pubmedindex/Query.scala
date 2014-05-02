package edu.arizona.sista.pubmedindex

import java.sql.Connection
import java.sql.Statement
import java.sql.Timestamp
import java.sql.ResultSet
import java.sql.Types

class Query(
    val connection: Connection, 
    val connectionKeepAlive: Boolean,
    val sql: String) {
  
	var resultSet: ResultSet = null
	val preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)
	
	def setParameter(index: Int, parameter: String) {
	  if(parameter == null)
	    preparedStatement.setNull(index, Types.NULL)
	  else
	    preparedStatement.setString(index, parameter);
	}
	
	def setParameter(index: Int, parameter: Boolean) {
	  if(parameter == null)
	    preparedStatement.setNull(index, Types.NULL)
	  else
	    preparedStatement.setBoolean(index, parameter);
	}
		
	def setParameter(index: Int, parameter: Integer) {
	  if(parameter == null)
	    preparedStatement.setNull(index, Types.NULL)
	  else
	    preparedStatement.setInt(index, parameter);
	}
	
	def setParameter(index: Int, parameter: Timestamp) = {
	  if(parameter == null)
	    preparedStatement.setNull(index, Types.NULL)
	  else
	    preparedStatement.setTimestamp(index, parameter);
	}
	
	def execute(): ResultSet = {
	  preparedStatement.execute();
	  return preparedStatement.getResultSet()
	}
	
	def getResultSet(): ResultSet = {
	  return resultSet
	}
	
	def close() {
	  if(resultSet != null)
		  resultSet.close
	  if(preparedStatement != null)
	    preparedStatement.close
	  if(!connectionKeepAlive && connection != null)
	    connection.close
	}
	
	def getGeneratedKeys(): ResultSet = {
	  return preparedStatement.getGeneratedKeys
	}
	
	def executeAndClose() {
	  execute
	  close
	}
	
	override def toString(): String = {
		return preparedStatement.toString()
	}

}