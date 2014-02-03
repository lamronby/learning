/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.lamronby.oo.tinyweb;

/**
 *
 * @author cjansen
 */
public class ControllerException  extends RuntimeException {
	private Integer statusCode;

	public ControllerException(Integer statusCode) {
		this.statusCode = statusCode;
	}

	public Integer getStatusCode() {
		return statusCode;
	}
}
