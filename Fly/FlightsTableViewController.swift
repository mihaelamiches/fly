//
//  FlightsViewController.swift
//  Fly
//
//  Created by Mihaela Miches on 6/11/17.
//  Copyright © 2017 me. All rights reserved.
//

import UIKit

class FlightsTableViewController : UITableViewController {
    var airport: Airport?
    var flights: [Cheapest] = []
    var best: [Trip] = []

    var inbound: [Cheapest] {
        return flights.filter { $0.origin.code == airport?.code }.byPrice()
    }
    
    var outbound: [Cheapest] {
        return flights.filter { $0.destination.code == airport?.code }.byPrice()
    }
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 144
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        title = airport?.name
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return best.count
        case 1:
            return outbound.count
        case 2:
            return inbound.count
        default: fatalError("wtf")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlightTableViewCell") as? FlightTableViewCell
                else { return UITableViewCell() }
            let flight = best[indexPath.row]
            cell.durationLabel?.text =  "\(flight.duration) days"
            cell.inboundLabel?.text = flight.inbound.day.shortString + " " + flight.inbound.price.description
            cell.outboundLabel?.text = flight.outbound.day.shortString + " " + flight.outbound.price.description
            cell.priceLabel?.text = flight.priceTag
            return cell
        }  else {
            let cell = UITableViewCell()
            let flight = indexPath.section == 1 ? outbound[indexPath.row] : inbound[indexPath.row]
            cell.textLabel?.text = flight.fares.first?.price.description
            cell.detailTextLabel?.text = flight.fares.first?.day.shortString
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let flight = flights[indexPath.row]
//        print(flight)
    }
}

