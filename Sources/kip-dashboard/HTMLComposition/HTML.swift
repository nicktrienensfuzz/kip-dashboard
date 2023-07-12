//
//  File.swift
//
//
//  Created by Nicholas Trienens on 6/23/23.
//

import Foundation

class HTML {
    var title = ""
    var styles = ""
    var styleImports = ""
    var body = ""
    var endOfBody = ""
    var jsImports = ""
    var jsOnload = ""
    var jsFunctions = ""

    func add(title: String = "", styles: String = "", styleImports: String = "", body: String = "", endOfBody: String = "", jsImports: String = "", jsOnload: String = "", jsFunctions: String = "") {
        self.title = title
        self.styles += "\n" + styles
        self.styleImports += "\n" + styleImports
        self.body += "\n" + body
        self.endOfBody += "\n" + endOfBody
        self.jsImports += "\n" + jsImports
        self.jsOnload += "\n" + jsOnload
        self.jsFunctions += "\n" + jsFunctions
    }

    func build() -> String {
        """
        <!doctype html>
        <html lang="en">

        <head>
          <!-- Required meta tags -->
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">

            <style>
            \(styles)
            </style>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-aFq/bzH65dt+w6FI2ooMVUpc+21e0SRygnTpmBvdBgSdnuTN7QbdgL+OapgHtvPp" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.3/font/bootstrap-icons.css">
          <link rel="stylesheet" href="css/styles.css">

        \(styleImports)

          <title>\(title)</title>
        </head>

        <body>
            <div class="container">
            \(body)
            </div>
            \(endOfBody)
        </body>



        <!-- Optional JavaScript -->
        <!-- jQuery first, then Popper.js, then Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.7.0.min.js" integrity="sha256-2Pmvv0kuTBOenSvLm6bvfBSSHrUJ+3A7x6P5Ebd07/g=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha2/dist/js/bootstrap.bundle.min.js" integrity="sha384-qKXV1j0HvMUeCBQ+QVp7JcfGl760yU08IQ+GpUo5hlbpg51QRiuqHAJz8+BrxE/N" crossorigin="anonymous"></script>
          <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
          <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.0/jspdf.umd.min.js"></script>

        \(jsImports)

        </body>

          <script>

            $(document).ready(function() {
                \(jsOnload)
            });

            \(jsFunctions)
          </script>
        </html>
        """
    }

    func addSpinner() {
        add(
            styles: """
            #overlay{
              position: fixed;
              top: 0;
              z-index: 100;
              width: 100%;
              height:100%;
              display: none;
              background: rgba(0,0,0,0.6);
            }
            .cv-spinner {
              height: 100%;
              display: flex;
              justify-content: center;
              align-items: center;
            }
            .spinner {
              width: 40px;
              height: 40px;
              border: 4px #ddd solid;
              border-top: 4px #2e93e6 solid;
              border-radius: 50%;
              animation: sp-anime 0.8s infinite linear;
            }
            @keyframes sp-anime {
              100% {
                transform: rotate(360deg);
              }
            }
            """,
            endOfBody: """
             <div id="overlay">
               <div class="cv-spinner">
                 <span class="spinner"></span>
               </div>
             </div>
            """,
            jsOnload: """
                $("#overlay").hide();
            """
        )
    }
}
