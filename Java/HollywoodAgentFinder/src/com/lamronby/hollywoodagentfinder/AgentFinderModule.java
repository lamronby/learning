/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.lamronby.hollywoodagentfinder;

import com.google.inject.AbstractModule;
import com.google.inject.Inject;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author cjansen
 */
public class AgentFinderModule extends AbstractModule {

    @Override
    protected void configure() {
        bind(AgentFinder.class).to(BogusAgentFinder.class);
    }
    
}
