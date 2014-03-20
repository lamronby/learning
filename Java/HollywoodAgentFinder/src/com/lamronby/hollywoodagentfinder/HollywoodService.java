/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.lamronby.hollywoodagentfinder;

import com.google.inject.Inject;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author cjansen
 */
public class HollywoodService {
    private AgentFinder finder = null;

    @Inject public HollywoodService(AgentFinder finder) {
        this.finder = finder;
    }

    public List<Agent> getFriendlyAgents() {
        List<Agent> agents = finder.findAllAgents();
        List<Agent> friendlyAgents = filterAgents(agents, "Java Developers");
        return friendlyAgents;
    }

    public List<Agent> filterAgents(List<Agent> agents, String agentType) {
        List<Agent> filteredAgents = new ArrayList<>();

        for (Agent agent:agents) {
            if ("Java Developers".equals(agent.getAgentType()))
                filteredAgents.add(agent);
        }

        return filteredAgents;
    }
}
