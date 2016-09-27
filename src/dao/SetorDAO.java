package dao;

import jdbc.ConexaoBD;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import modelo.Setor;

public class SetorDAO {
	private Connection connection;
	
	public SetorDAO(){
		this.connection = new ConexaoBD().getConexaoBD();
	}
	public void fechaConexao(){
		try{
			connection.close();
		}catch (SQLException e){
			throw new RuntimeException(e);			
		}
	}
	
	//Busca infos de algum setor
	public List<Setor> buscaSetor (String orgao, String nome){
		List<Setor> setores = new ArrayList<Setor>();
		PreparedStatement stmt;
		String sql;
		
		sql = "SELECT * from setores WHERE orgao like ? and nome like ?";
		try{
			stmt = connection.prepareStatement(sql);
			stmt.setString(1, orgao);
			stmt.setString(2, nome);
			
			ResultSet rs = stmt.executeQuery();
			
			while (rs.next()){
				Setor setor = new Setor();
				setor.setOrgao(rs.getString("orgao"));
				setor.setNome(rs.getString("nome"));
				setor.setEndereco(rs.getString("endereco"));
				setor.setCep(rs.getString("cep"));
				setor.setTelefone(rs.getString("telefone"));
				setor.setEmail(rs.getString("email"));
				setor.setSite(rs.getString("site"));
				
				setores.add(setor);
			}
			rs.close();
			stmt.close();
		}catch (SQLException e){
			throw new RuntimeException(e);
		}
		return setores;
	}
	
	//Retorna lista com nomes dos setores de um determinado orgao (Secretaria ou Subprefeitura)
	public List<String> listaSetor (String orgao){
		List<String> setor = new ArrayList<String>();
		PreparedStatement stmt;
		String sql;
		
		sql = "SELECT nome from setores WHERE orgao ?";
		try{
			stmt = connection.prepareStatement(sql);
			stmt.setString(1, orgao);
			
			ResultSet rs = stmt.executeQuery();
			
			while (rs.next()){
				String nome = rs.getString("nome");
				
				setor.add(nome);
			}
			rs.close();
			stmt.close();
		}catch (SQLException e){
			throw new RuntimeException(e);
		}
		return setor;
	}
	
	//Busca setor que corresponde ao que foi digitado na barra de busca
	public String barraBusca (String busca){
		String setor = "";
		PreparedStatement stmt;
		String sql;
		
		sql = "SELECT * from setores WHERE nome like ? ";
		try{
			stmt = connection.prepareStatement(sql);
			stmt.setString(1, "%"+busca+"%");
			
			ResultSet rs = stmt.executeQuery();
			
			setor = rs.getString("nome");
			
			rs.close();
			stmt.close();
		}catch (SQLException e){
			throw new RuntimeException(e);
		}
		return setor;
	}
}