/*Faz a conexao com o BD com acesso ao database organograma */
package jdbc;

import java.sql.*;

public class ConexaoBD {
	public Connection getConexaoBD(){
		System.out.println("Conectando ao Banco de Dados");
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url= "jdbc:mysql://10.20.18.18/organograma";
			//String url= "jdbc:mysql://localhost/organograma";
			return DriverManager.getConnection(url, "root", "");
		}catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
