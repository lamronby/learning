/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.lamronby.hollywoodagentfinder;

/**
 *
 * @author cjansen
 */
public class Agent {
    protected String name;
    protected String phoneNumber;
    protected String emailAddress;
    protected String agentType;

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the phoneNumber
     */
    public String getPhoneNumber() {
        return phoneNumber;
    }

    /**
     * @param phoneNumber the phoneNumber to set
     */
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    /**
     * @return the emailAddress
     */
    public String getEmailAddress() {
        return emailAddress;
    }

    /**
     * @param emailAddress the emailAddress to set
     */
    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }
    
    /**
     * @return the agentType
     */
    public String getAgentType() {
        return agentType;
    }

    /**
     * @param agentType the agentType to set
     */
    public void setAgentType(String agentType) {
        this.agentType = agentType;
    }
    
    public Agent(String name, String phoneNumber, String emailAddress, String agentType) {
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.emailAddress = emailAddress;
        this.agentType = agentType;
    }

    @Override
    public String toString() {
        return ("Name: " + name + ", Phone: " + phoneNumber + ", Email: " + emailAddress + ", Type: " + agentType);
    }
}
