import fs from 'fs';
import lighthouse from 'react-ts-vite/scripts/lighthouse.mjs';
import chromeLauncher from 'chrome-launcher';

const targetURL = process.env.LIGHTHOUSE_TARGET_URL
let numOfRuns = process.env.LIGHTHOUSE_RUN_COUNT

const MAX_RUN_COUNT = 15;
const DEFAULT_RUN_COUNT = 5;

const execute = async () => {
    let scores = {
        performance: [],
        pwa: [],
        a11y: [],
    };

    if (!targetURL) {
        throw new Error("invalid target URL");
    }

    if (!numOfRuns) {
        numOfRuns = DEFAULT_RUN_COUNT;
    }

    if (numOfRuns > MAX_RUN_COUNT) {
        console.log("it seems like you've specified a run count higher than the max. we're going to lower that for you.")
        numOfRuns = MAX_RUN_COUNT;
    }

    // initialize chrome
    const chrome = await chromeLauncher.launch({chromeFlags: ['--headless']});
    const options = { output: 'json', onlyCategories: ['performance', 'pwa', 'accessibility'], port: chrome.port};

    console.log("Starting lighthouse runs")
    for (let i = 0; i < numOfRuns; i++) {
        const runnerResult = await lighthouse(targetURL, options);
        scores.performance.push(runnerResult.lhr.categories.performance.score * 100)
        scores.pwa.push(runnerResult.lhr.categories.pwa.score * 100)
        scores.a11y.push(runnerResult.lhr.categories.accessibility.score * 100)
        console.log(`Run #${i+1} complete...`)
    }

    // calculate average
    console.log("Calculating average...")
    Object.keys(scores).forEach((k) => {
        scores[k] = [generateScoreAverage(scores[k])]
    })

    console.log("Tearing down lighthouse...")
    await chrome.kill()

    generateBasicReportFile(scores)
}

const formatDate = () => {
    return new Date().toString().substr(0, 24).replaceAll(" ", "-")
}

const generateBasicReportFile = (scores) => {
    const normalizedOutput = {
        url: targetURL,
        time: formatDate(),
        performance: scores.performance[0],
        pwa: scores.pwa[0],
        a11y: scores.a11y[0],
    }

    console.log("writing output to file...")
    fs.writeFileSync(`lighthouse-report-basic_${formatDate()}.json`, JSON.stringify(normalizedOutput));
    console.log("done!\n--------")
    logBasicReport(normalizedOutput)
}

const generateScoreAverage = (scores) => {
    if (!scores.length) return

    let total = 0;

    scores.forEach((result) => {
        total += result
    })

    return total / scores.length;
}

const logBasicReport = (basicReport) => {
    console.log(`${numOfRuns} runs completed for ${basicReport.url} at ${basicReport.time}`)
    console.log('Performance score:', basicReport.performance);
    console.log('PWA score:', basicReport.pwa);
    console.log('A11y score:', basicReport.a11y);
}

execute().catch(err => console.error("script error: ", err))