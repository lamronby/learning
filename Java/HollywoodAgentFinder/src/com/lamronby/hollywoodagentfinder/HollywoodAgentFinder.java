/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.lamronby.hollywoodagentfinder;

import com.google.inject.Guice;
import com.google.inject.Injector;
import java.util.List;

/**
 *
 * @author cjansen
 */
public class HollywoodAgentFinder {
    
    public static void main(String[] args) {
        Injector injector = Guice.createInjector(new AgentFinderModule());
        
        HollywoodService hollywoodService = injector.getInstance(HollywoodService.class);
        
        List<Agent> agents = hollywoodService.getFriendlyAgents();
        
        for (Agent agent:agents) {
            System.out.println("Matching agent: " + agent);
        }
    }
}
