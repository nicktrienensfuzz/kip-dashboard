//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 6/23/23.
//

import Foundation
import Hummingbird

extension kip_dashboard {
    
    func configure(_ app: HBApplication) {
        
        app.router.get("/test") { request -> HBResponse in
            let body = HTML()
            body.add(title: "testing", body: """
                     <h1>hello</h1>

                     <section class="charts">
                       <div class="widget">
                         <div class="widget-header">
                           <span>Orders By Store per Week</span>
                           <button type="button" class="export-button" onclick="exportChart('line-chart', [15, 15, 280, 170])">
                             Export
                           </button>
                         </div>
                         
                         <div class="chart" style="padding: 15px">
                           <canvas id="line-chart" width="1000" height="450"></canvas>
                         </div>
                       </div>
                     </section>
                     """,
                     jsOnload: """
                      $.ajax({
                        type: 'GET',
                        url: 'allLocationsOrdersByDay.json',
                        contentType: 'application/json',
                        success: function(response) {
                            // handle success
                            let data = JSON.parse(response)
                            let stores = data.stores
                
                            const lineElement = document.getElementById('line-chart').getContext('2d');
                            
                            console.log(data.labels);
                            const lineData = {
                              labels: data.labels,
                              datasets: [
                                jQuery.map( stores, function( store, i ) {
                                    console.log(store);

                                   return {
                                       label: store.name,
                                       data: store.data,
                                  
                                    }
                                })
                            ]
                            };

                            const lineConfig = {
                              type: 'line',
                              data: lineData,
                            };
                            console.log(lineElement);
                            console.log(lineData);
                
                            const lineChart = new Chart(
                              lineElement,
                              lineConfig
                            );
                
                        },
                        error: function(error) {
                          // handle error
                          console.log(error);
                          $(".spinner-border").hide()
                        }
                      });
                """)
            
            body.addSpinner()
            body.add(
                body: """
                     <section class="charts">
                       <div class="widget">
                         <div class="widget-header">
                           <span>Orders By Store per Week</span>
                           <button type="button" class="export-button" onclick="exportChart('line-chart', [15, 15, 280, 170])">
                             Export
                           </button>
                         </div>
                         
                         <div class="chart" style="padding: 15px">
                           <canvas id="bar-chart" width="1000" height="450"></canvas>
                         </div>
                       </div>
                     </section>
                """,
                jsOnload: """
                      $.ajax({
                        type: 'GET',
                        url: 'locations.json', // replace with your actual submission URL
                        contentType: 'application/json',
                        success: function(response) {
                            // handle success
                            let stores = JSON.parse(response)
                            console.log(stores[0]);
                            const barChartElement = document.getElementById('bar-chart').getContext('2d');
                            
                            const barLabels = [
                              '10 days',
                                '20 days',
                            ];
                
                            const barData = {
                              labels: barLabels,
                              datasets:
                                jQuery.map( stores, function( store, i ) {
                                  return {
                                       label: store.name,
                                       data: store.data,
                                       backgroundColor: [
                                            eval(store.colorString),
                                       ],
                                       borderWidth: 1
                                    }
                                })
                            };

                            const configBar = {
                              type: 'bar',
                              data: barData,
                              options: {
                                scales: {
                                  y: {
                                    beginAtZero: true
                                  }
                                }
                              },
                            };

                            const barChart = new Chart(
                              barChartElement,
                              configBar
                            );

                
                        },
                        error: function(error) {
                          // handle error
                          console.log(error);
                          $(".spinner-border").hide()
                        }
                      });
                """)

            
            return try HBResponse(status: .ok, headers: .init([("contentType", "text/html")]), body: .data( body.build().asData.unwrapped()))
        }
    }
}
