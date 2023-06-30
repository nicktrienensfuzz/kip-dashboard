const puppeteer = require('puppeteer')
 
async function printPDF() {
  const browser = await puppeteer.launch({ headless: "new" });
  const page = await browser.newPage();
  let url = "http://localhost:9000/"
  // let url = 'http://127.0.0.1:8080/'
  await page.goto(url, {waitUntil: 'networkidle0'});
  //const pdf = await page.pdf({ format: 'A4' });
  const pdf = await page.pdf({ path: 'bluejay dashboard.pdf', format: 'A4' });

  await browser.close();
  return pdf
};

printPDF()