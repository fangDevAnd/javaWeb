package com.fang.model;

public class Classfy {

	private int id;
	private String name;
	private String image;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	
	
	public Classfy() {
		
	}
	
	public Classfy(int id, String name, String image) {
		super();
		this.id = id;
		this.name = name;
		this.image = image;
	}
	
	
	
	
	
	
}
