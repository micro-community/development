# mdns discovery

MDNS discovery is used in single server or LAN

## Overview

MDNS is universal discovery uses multicast dns capabilities

## Implemenations

To use mdns as registry we need to represent registry stuff via mdns records.

Options      => to speedup resolving of nodes need to specify refresh interval, registry in
                async fashion send multicast to get all services? or specify timeout for each query?
                domain to use

ListServices => multicast request to get srv records _micro_services.local, 
                in response server reply with srv records of service nodes?
               
GetService   => multicast request to get srv record, in response server reply
                with srv record of service node and attach txt record?
                to get nodes query A/AAAA records for node name?
                
Register     => fill map with service, and send multicast with A/AAAA/SRV/TXT/PTR records
                TXT: endpoints metadata, SRV: service.Name <=> node.Id and Port, 
                A/AAAA: node.Id <=> node.Address, PTR: service.Name <=> node.Id
                say that   // not announce faster when 10 times at minute
                           // https://tools.ietf.org/html/rfc6762#section-8.4

Deregister   => delete from map and send multicast

Watch        => watch register/deregister stuff and send results
