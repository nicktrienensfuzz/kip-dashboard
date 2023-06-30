const puppeteer = require('puppeteer')
 
async function printPDF() {
  const browser = await puppeteer.launch({ headless: "new" });
  const page = await browser.newPage();
  await page.goto('http://127.0.0.1:8080/', {waitUntil: 'networkidle0'});
  //const pdf = await page.pdf({ format: 'A4' });
  const pdf = await page.pdf({ path: 'bluejay dashboard.pdf', format: 'A4' });

  await browser.close();
  return pdf
};

printPDF()