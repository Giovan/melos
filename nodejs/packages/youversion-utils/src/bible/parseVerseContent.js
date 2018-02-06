export default function parseVerseFromContent({ usfms, fullContent }) {
	const textOutput = []
	const htmlOutput = []

	const isServerRendering = typeof window === 'undefined'
	let doc, xpath
	if (isServerRendering) {
		// parsing on the server
		xpath = require('xpath')
		const Parser = require('xmldom').DOMParser
		doc = new Parser().parseFromString(fullContent)
	} else {
		doc = new DOMParser().parseFromString(fullContent, 'text/html')
	}

	if (usfms && fullContent) {
		let usfmList = []
		// convert string or array to appropriate split array to single out every verse
		// i.e. [rev.20.1, rev.20.4+rev.20.5+rev.20.6] -> [rev.20.1, rev.20.4, rev.20.5, rev.20.6]
		// or rev.20.4+rev.20.5+rev.20.6 -> [rev.20.4, rev.20.5, rev.20.6]
		if (Array.isArray(usfms)) {
			let split = []
			usfms.forEach((usfm) => {
				split = split.concat(usfm.split('+'))
			})
			usfmList = split
		} else {
			usfmList = usfms.split('+')
		}

		usfmList.forEach((usfm) => {
			const htmlXpath = `//div/div/div/span[contains(concat('+',@data-usfm,'+'),'+${usfm}+')]`
			const textXpath = `${htmlXpath}/node()[not(contains(concat(\' \',@class,\' \'),\' note \'))][not(contains(concat(\' \',@class,\' \'),\' label \'))]`

			let html, text
			if (isServerRendering) {
				html = xpath.evaluate(htmlXpath, doc, null, xpath.XPathResult.ANY_TYPE, null)
				text = xpath.evaluate(textXpath, doc, null, xpath.XPathResult.ANY_TYPE, null)
			} else {
				html = doc.evaluate(htmlXpath, doc, null, XPathResult.ANY_TYPE, null)
				text = doc.evaluate(textXpath, doc, null, XPathResult.ANY_TYPE, null)
			}

			// text
			let nextText = text.iterateNext()
			while (nextText) {
				textOutput.push(nextText.textContent)
				nextText = text.iterateNext()
			}
			// html
			let nextHtml = html.iterateNext()
			while (nextHtml) {
				const htmlContent = isServerRendering
					? nextHtml.toString()
					: nextHtml.outerHTML
				htmlOutput.push(htmlContent)
				nextHtml = html.iterateNext()
			}
		})
	}

	return {
		text: textOutput
			.join(' ')
			.replace(/\s\s+/g, ' '),
		html: htmlOutput.join(' ')
	}
}
