const express = require('express');
const puppeteer = require('puppeteer')
var audit = require('express-requests-logger')

const app = express();
const PORT = 80;

app.use(express.static('.'));
app.use(audit({ response: {
    excludeBody: ["*"], // Exclude all body from responsess
    maxBodyLength: 50 // limit length to 50 chars + '...'
}
}));

app.get('/hi', (req, res) => {
    res.send('Hello World!');
});

async function printPDF() {
    const browser = await puppeteer.launch({ headless: "new" });
    const page = await browser.newPage();
    await page.goto('http://127.0.0.1:8080/', {waitUntil: 'networkidle0'});
    //const pdf = await page.pdf({ format: 'A4' });
    const pdf = await page.pdf({ path: 'export.pdf', format: 'A4' });
  
    await browser.close();
    return pdf
};

app.get('/', function(req, res) {

    // Launching the Puppeteer controlled headless browser and navigate to the Digimon website
    puppeteer.launch().then(async function(browser) {
        const page = await browser.newPage();
        await page.goto('http://digidb.io/digimon-list/');

        // Targeting the DOM Nodes that contain the Digimon names
        const digimonNames = await page.$$eval('#digiList tbody tr td:nth-child(2) a', function(digimons) {
        // Mapping each Digimon name to an array
            return digimons.map(function(digimon) {
          return digimon.innerText;
        });
      });

        // Closing the Puppeteer controlled headless browser
        await browser.close();

        // Sending the Digimon names to Postman
        res.send(digimonNames);
    });
});

app.get('/stop', function(req, res) {
    res.send("goodbye");
    process.exit()
});

app.get('/try', async function(req, res) { 
    const javaInfo = await execShellCommand('swift --version');
    console.log(javaInfo);
    res.send(javaInfo);
});

app.get('/pdf', function(req, res) {

    // Launching the Puppeteer controlled headless browser and navigate to the Digimon website
    puppeteer.launch().then(async function(browser) {
        const page = await browser.newPage();
        await page.goto('http://digidb.io/digimon-list/');

    //     // Targeting the DOM Nodes that contain the Digimon names
    //     const digimonNames = await page.$$eval('#digiList tbody tr td:nth-child(2) a', function(digimons) {
    //     // Mapping each Digimon name to an array
    //         return digimons.map(function(digimon) {
    //       return digimon.innerText;
    //     });
    //   });
        const pdf = await page.pdf({ format: 'A4' });

        // Closing the Puppeteer controlled headless browser
        await browser.close();

        // Sending the Digimon names to Postman
        res.send(pdf);
    });
});

app.listen(PORT, () => console.log(`Server listening on port: ${PORT}`));



function execShellCommand(cmd) {
    const exec = require('child_process').exec;
    return new Promise((resolve, reject) => {
     exec(cmd, (error, stdout, stderr) => {
      if (error) {
       console.warn(error);
      }
      resolve(stdout? stdout : stderr);
     });
    });
   }