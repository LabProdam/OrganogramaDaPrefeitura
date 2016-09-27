package dao;

import jdbc.ConexaoBD;
import java.sql.*;
import java.text.ParseException;
import java.util.Date;
import java.text.SimpleDateFormat;
import modelo.Funcionario;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

public class FuncionarioDAO {
	private Connection connection;

	public FuncionarioDAO(){
		this.connection = new ConexaoBD().getConexaoBD();
	}
	public void fechaConexao(){
		try{
			connection.close();
		}catch (SQLException e){
			throw new RuntimeException(e);
		}
	}

	//Verifica se o funcionário está ativo
	public boolean estado(String adm, String exon){
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		boolean estado= false;

		try {
			Date admissao = formato.parse(adm);
			Date exoneracao = formato.parse(exon);
			Date todayDate = zeraHoraDataAtual();
			//System.out.println("estado Hoje: "+todayDate);
			//System.out.println("estado Admissao: "+admissao);
			//System.out.println("estado Exoneração: "+exoneracao);
			if((todayDate.before(exoneracao) || todayDate.equals(exoneracao)) && (todayDate.after(admissao) || todayDate.equals(admissao))){
			estado = true;
			}else estado = false;

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return estado;
	}
	
	public boolean fimFerias(String exon){
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		boolean estado= false;
		
		try {
			Date exoneracao = formato.parse(exon);
			Date todayDate = zeraHoraDataAtual();
			//System.out.println("estado Hoje: "+todayDate);
			//System.out.println("estado Admissao: "+admissao);
			//System.out.println("estado Exoneração: "+exoneracao);
			if(todayDate.after(exoneracao)){
			estado = true;
			}else estado = false;

		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return estado;
	}

	//Limpa dados de SUBSTITUTO no BD
	public void limpaDados(String cargo, String orgao, String setor){
		PreparedStatement stmt;
		String sql;

		sql = "UPDATE funcionarios SET substituto=NULL, entrada=NULL, saida=NULL WHERE cargo=? AND orgao=? AND setor=?";
		try{
			stmt = connection.prepareStatement(sql);
			stmt.setString(1, cargo);
			stmt.setString(2, orgao);
			stmt.setString(3, setor);
			stmt.execute();
			stmt.close();
		}catch(SQLException e){
			throw new RuntimeException(e);
		}
	}

	//Zera hora da data atual
	public Date zeraHoraDataAtual(){
		Calendar currentCalendar = Calendar.getInstance();
		Date todayDate = new Date();

		currentCalendar.setTime(todayDate);
		currentCalendar.set(Calendar.HOUR_OF_DAY, 0);
		currentCalendar.set(Calendar.MINUTE, 0);
		currentCalendar.set(Calendar.SECOND, 0);
		currentCalendar.set(Calendar.MILLISECOND, 0);
		todayDate = currentCalendar.getTime();

		return todayDate;
	}


	//Faz a busca dos funcionarios por CARGO considerando SUBSTITUTO
		public List<Funcionario> buscaCargo(String cargo, String orgao){
			List<Funcionario> funcionarios = new ArrayList<Funcionario>();
			PreparedStatement stmt;
			String sql;

			sql = "SELECT * from funcionarios WHERE cargo=? AND orgao=? ORDER BY field(setor, 'Governo Municipal')DESC, setor ASC";
			try{
				stmt = connection.prepareStatement(sql);
				stmt.setString(1, cargo);
				stmt.setString(2, orgao);
				ResultSet rs = stmt.executeQuery();
				while (rs.next()){
					Funcionario funcionario = new Funcionario();

					funcionario.setId(rs.getLong("id"));
					funcionario.setCargo(rs.getString("cargo"));
					funcionario.setOrgao(rs.getString("orgao"));
					funcionario.setSetor(rs.getString("setor"));

					if(rs.getString("substituto")==null && rs.getString("entrada")==null && rs.getString("saida")==null){
						funcionario.setNome(rs.getString("nome"));
						funcionario.setAdmissao(rs.getString("admissao"));
						funcionario.setExoneracao(rs.getString("exoneracao"));
					}else{
						boolean ferias = estado(rs.getString("entrada"), rs.getString("saida"));
						if(ferias){
							funcionario.setNome(rs.getString("substituto")+"*");
							funcionario.setAdmissao(rs.getString("entrada"));
							funcionario.setExoneracao(rs.getString("saida"));
						}else if(fimFerias(rs.getString("saida"))){
							limpaDados(cargo, orgao, rs.getString("setor"));
							funcionario.setNome(rs.getString("nome"));
							funcionario.setAdmissao(rs.getString("admissao"));
							funcionario.setExoneracao(rs.getString("exoneracao"));
						}else{
							funcionario.setNome(rs.getString("nome"));
							funcionario.setAdmissao(rs.getString("admissao"));
							funcionario.setExoneracao(rs.getString("exoneracao"));							
						}
					}
					funcionarios.add(funcionario);
				}
				rs.close();
				stmt.close();
			}catch (SQLException e) {
				throw new RuntimeException(e);
			}
			return funcionarios;
		}

	//Faz a busca dos funcionarios por SETOR considerando SUBSTITUTO
			public List<Funcionario> buscaSetor(String cargo, String orgao, String setor){

				List<Funcionario> funcionarios = new ArrayList<Funcionario>();
				PreparedStatement stmt;
				String sql;

				sql = "SELECT * from funcionarios WHERE cargo=? AND orgao=? AND setor=?";
				try{
					stmt = connection.prepareStatement(sql);
					stmt.setString(1, cargo);
					stmt.setString(2, orgao);
					stmt.setString(3, setor);
					ResultSet rs = stmt.executeQuery();
					while (rs.next()){
						Funcionario funcionario = new Funcionario();

						funcionario.setId(rs.getLong("id"));
						funcionario.setCargo(rs.getString("cargo"));
						funcionario.setOrgao(rs.getString("orgao"));
						funcionario.setSetor(rs.getString("setor"));

						if(rs.getString("substituto")==null && rs.getString("entrada")==null && rs.getString("saida")==null){
							funcionario.setNome(rs.getString("nome"));
							funcionario.setAdmissao(rs.getString("admissao"));
							funcionario.setExoneracao(rs.getString("exoneracao"));
						}else{
							boolean ferias = estado(rs.getString("entrada"), rs.getString("saida"));
							if(ferias){
								funcionario.setNome(rs.getString("substituto")+"*");
								funcionario.setAdmissao(rs.getString("entrada"));
								funcionario.setExoneracao(rs.getString("saida"));
							}else if(fimFerias(rs.getString("saida"))){
								limpaDados(cargo, orgao, rs.getString("setor"));
								funcionario.setNome(rs.getString("nome"));
								funcionario.setAdmissao(rs.getString("admissao"));
								funcionario.setExoneracao(rs.getString("exoneracao"));
							}else{
								funcionario.setNome(rs.getString("nome"));
								funcionario.setAdmissao(rs.getString("admissao"));
								funcionario.setExoneracao(rs.getString("exoneracao"));							
							}
						}
						funcionarios.add(funcionario);
					}
					rs.close();
					stmt.close();
				}catch (SQLException e) {
					throw new RuntimeException(e);
				}
				return funcionarios;
			}

	//Lista TODOS os funcionarios
	public List<Funcionario> getLista(){
		List<Funcionario> funcionarios = new ArrayList<Funcionario>();

		PreparedStatement stmt;
		try{
			stmt = this.connection.prepareStatement("select * from funcionarios order by id");
			ResultSet rs = stmt.executeQuery();
			while(rs.next()){
				Funcionario funcionario = new Funcionario();

				funcionario.setId(rs.getLong("id"));
				funcionario.setNome(rs.getString("nome"));
				funcionario.setCargo(rs.getString("cargo"));
				funcionario.setOrgao(rs.getString("orgao"));
				funcionario.setSetor(rs.getString("setor"));
				funcionario.setAdmissao(rs.getString("admissao"));
				funcionario.setExoneracao(rs.getString("exoneracao"));

				funcionarios.add(funcionario);
			}
			rs.close();
			stmt.close();
		}catch (SQLException e) {
			throw new RuntimeException(e);
		}
		return funcionarios;

	}

}
