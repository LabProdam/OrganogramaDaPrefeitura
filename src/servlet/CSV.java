/*Pega dados do BD e gera um arquivo csv, neste caso separado por ';'
para que abra no formato de colunas no excel*/
package servlet;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Iterator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jdbc.ConexaoBD;
import modelo.Funcionario;
import modelo.Setor;


@WebServlet("/CSV")
public class CSV extends HttpServlet {
	private Connection connection;

	public void fechaConexao(){
		try{
			connection.close();
		}catch(SQLException e){
			throw new RuntimeException(e);
		}
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		this.connection = new ConexaoBD().getConexaoBD();
		
		response.setContentType("text/csv");
	    response.setHeader("Content-Disposition", "attachment; filename=\"organograma.csv\"");

	    ArrayList<String> rows = new ArrayList<String>();
        rows.add("Nome;Cargo;Órgão;Setor;Substituto;Entrada;Saída;Email;Endereço;Cep;Telefone;Site");
        rows.add("\n");

	    ArrayList<Funcionario> funcionarios = new ArrayList<Funcionario>();
	    ArrayList<Setor> setores = new ArrayList<Setor>();

	    PreparedStatement stmt;
		//Query que tras os dados do BD na ordem em que devem ser exibidos no arquivo csv
    	String sql = "SELECT F.nome, F.cargo, F.orgao, F.setor, F.substituto, F.entrada, F.saida, S.endereco, S.cep, S.telefone, S.email, S.site "
    			+ "FROM funcionarios F "
    			+ "INNER JOIN setores S "
    			+ "ON F.setor=S.nome "
    			+ "order by  field(F.orgao, 'Prefeitura', 'Controladoria', 'Procuradoria', 'Secretaria', 'Subprefeitura'),"
    			+ "setor, "
    			+ "field(cargo, 'Prefeito', 'Controlador Geral', 'Procurador Geral', 'Secretário', 'Subprefeito', 'Vice-Prefeito', 'Controlador Geral Adjunto', 'Procurador Geral Adjunto', 'Secretário Adjunto', 'Chefe de Gabinete')";

	    try
	    {
	    	stmt = connection.prepareStatement(sql);
	    	ResultSet rs = stmt.executeQuery();
	    	while (rs.next()){
	    		Funcionario funcionario = new Funcionario();
	    		Setor setor = new Setor();

				funcionario.setNome(rs.getString("nome"));
				
				String cargo = rs.getString("cargo");
				if(cargo.equals("Prefeito")) funcionario.setCargo(cargo);
				else if(cargo.equals("Vice-Prefeito")) funcionario.setCargo("Vice-Prefeita");
				else if(cargo.equals("Secretário Adjunto")) funcionario.setCargo("Secretário(a) Adjunto(a)");	
				else if(cargo.equals("Controlador Geral Adjunto")) funcionario.setCargo("Controlador(a) Geral Adjunto(a)");
				else if(cargo.equals("Controlador Geral")) funcionario.setCargo("Controlador(a) Geral");
				else if(cargo.equals("Procurador Geral Adjunto")) funcionario.setCargo("Procurador(a) Geral Adjunto(a)");
				else if(cargo.equals("Procurador Geral")) funcionario.setCargo("Procurador(a) Geral");
				else if(cargo.equals("Chefe de Gabinete")) funcionario.setCargo(cargo);
				else funcionario.setCargo(cargo + "(a)");
				
				funcionario.setOrgao(rs.getString("orgao"));
				funcionario.setSetor(rs.getString("setor"));
				funcionario.setSubstituto(rs.getString("substituto"));
				funcionario.setEntrada(rs.getString("entrada"));
				funcionario.setSaida(rs.getString("saida"));
				setor.setOrgao(rs.getString("orgao"));
				setor.setNome(rs.getString("nome"));
				
				//Pega o endereço correto do vice-prefeito,que difere no endereço dos outros membros da prefeitura
				if(rs.getString("cargo").equals("Vice-Prefeito")) setor.setEndereco("Viaduto do Chá, 15 - 6º andar - "
						+ "Edifício Matarazzo - Centro - São Paulo - SP");
				else setor.setEndereco(rs.getString("endereco"));
				
				setor.setCep(rs.getString("cep"));
				setor.setTelefone(rs.getString("telefone"));
				setor.setEmail(rs.getString("email"));
				setor.setSite(rs.getString("site"));

				funcionarios.add(funcionario);
				setores.add(setor);
	    	}
	    }catch (SQLException e){
	    	throw new RuntimeException(e);
	    }

		 //Adiciona o conteudo no csv verificando os campos nulos, os substituindo por um espaco em branco
	   for(int i=0; i<funcionarios.size(); i++){
    		if(funcionarios.get(i).getNome()!=null) rows.add("\""+funcionarios.get(i).getNome()+"\";");
				else rows.add(";");
    		if(funcionarios.get(i).getCargo()!=null) rows.add("\""+funcionarios.get(i).getCargo()+"\";");
				else rows.add(";");
			if(funcionarios.get(i).getOrgao()!=null) rows.add("\""+funcionarios.get(i).getOrgao()+"\";");
				else rows.add(";");
			if(funcionarios.get(i).getSetor()!=null) rows.add("\""+funcionarios.get(i).getSetor()+"\";");
				else rows.add(";");
			if(funcionarios.get(i).getSubstituto()!=null) rows.add("\""+funcionarios.get(i).getSubstituto()+"\";");
				else rows.add(";");
			if(funcionarios.get(i).getEntrada()!=null) rows.add("\""+funcionarios.get(i).getEntrada()+"\";");
				else rows.add(";");
			if(funcionarios.get(i).getSaida()!=null) rows.add("\""+funcionarios.get(i).getSaida()+"\";");
				else rows.add(";");
			if(setores.get(i).getEmail()!=null) rows.add("\""+setores.get(i).getEmail()+"\";");
				else rows.add(";");
			if(setores.get(i).getEndereco()!=null) rows.add("\""+setores.get(i).getEndereco()+"\";");
				else rows.add(";");
			if(setores.get(i).getCep()!=null) rows.add("\""+setores.get(i).getCep()+"\";");
				else rows.add(";");
			if(setores.get(i).getTelefone()!=null) rows.add("\""+setores.get(i).getTelefone()+"\";");
				else rows.add(";");
			if(setores.get(i).getSite()!=null) rows.add("\""+setores.get(i).getSite()+"\"\n");
				else rows.add(";\n");
    	}

    	Iterator<String> iter = rows.iterator();
        while (iter.hasNext()){
            String outputString = (String) iter.next();
            response.getOutputStream().print(outputString);
        }

        response.getOutputStream().flush();
        response.getOutputStream().close();
        
        fechaConexao();
	}
}
