# URM - Unified Release Management

## Overview

  URM is a tool set enabling to set up continuous delivery framework, aligned with complex release policies:
  - Linux-based command center, powerful command-line interface
  - Linux/Windows builds and deployments, maven/gradle/dotnet
  - full/incremental releases for generic multi-datacenter application sets
  - build and deployments without writing scripts, compact declarative tobe-specifications
  - align with specific technologies, not replacing with its own
  - multi-repository codebase management, svn/git repositories
  - multi-datacenter geterogenious environment management, flexible but controlled configurations
  - enforce engineering product management
  - enforce storing codebase in repositories for buildable, configuration files and database modification files
  - enforce storing all artefacts required for automatic deployment in well-defined distributive packages
  - multi-team environment
  - release planning control
  - messaging integrations
  
## Installation

  - create home directory
  - export urm/master to home/master
  - create home/etc
  - create in home/etc configuration files product.conf, distr.xml, source.xml using sample files in urm/master/samples
  - make sure all .sh files are executable and have Linix linefeeds:
    : chmod 744 `find . -name "*.sh`
    : sed -i "s/\r//" `find . -name "*.sh`

  
