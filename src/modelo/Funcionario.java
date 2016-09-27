package modelo;


public class Funcionario {
	private Long id;
	private String nome;
	private String cargo;
	private String orgao;
	private String setor;
	private String admissao ;
	private String exoneracao ;
	private String estado;
	private String substituto;
	private String entrada;
	private String saida;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getCargo() {
		return cargo;
	}
	public void setCargo(String cargo) {
		this.cargo = cargo;
	}
	public String getOrgao() {
		return orgao;
	}
	public void setOrgao(String orgao) {
		this.orgao = orgao;
	}
	public String getSetor() {
		return setor;
	}
	public void setSetor(String setor) {
		this.setor = setor;
	}
	public String getAdmissao() {
		return admissao;
	}
	public void setAdmissao(String admissao) {
		this.admissao = admissao;
	}
	public String getExoneracao() {
		return exoneracao;
	}
	public void setExoneracao(String exoneracao) {
		this.exoneracao = exoneracao;
	}
	public String getEstado() {
		return estado;
	}
	public void setEstado(String estado) {
		this.estado = estado;
	}
	public String getSubstituto() {
		return substituto;
	}
	public void setSubstituto(String substituto) {
		this.substituto = substituto;
	}
	public String getEntrada() {
		return entrada;
	}
	public void setEntrada(String entrada) {
		this.entrada = entrada;
	}
	public String getSaida() {
		return saida;
	}
	public void setSaida(String saida) {
		this.saida = saida;
	}
}