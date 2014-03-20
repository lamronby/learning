/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.lamronby.hollywoodagentfinder;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author cjansen
 */
public class BogusAgentFinder implements AgentFinder {

    private final ArrayList<Agent> agents;
    
    public BogusAgentFinder() {
        agents = new ArrayList<>();
        
        agents.add(new Agent("John Chalufin", "303-555-0122", "jchalufin@hollywood.com", "C# Developers"));
        agents.add(new Agent("Ephraim Huckabee", "334-555-0103", "ehuckabee@hollywood.com", "Java Developers"));
        agents.add(new Agent("Yakov Freakinov", "801-555-2123", "yfreakinov@hollywood.com", "Java Developers"));
        
    }
    
    @Override
    public List<Agent> findAllAgents() {
        return agents;
    }
    
}
