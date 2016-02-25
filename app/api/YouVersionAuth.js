import Promise from 'bluebird'
import https from 'https'
import { fetchToken } from '@youversion/token-storage'

function handleRequest(path, method, postBody) {
	return new Promise(function(resolve, reject) {
		let headers = {
			'Content-Type': 'application/json'
		}

		if (method === 'POST') {
			headers['Content-Length'] = Buffer.byteLength(postBody, 'utf8')
		}

		const token = fetchToken()
		if (typeof token === 'string' && token.length > 0) {
			headers['authorization'] = 'Bearer ' + token
		}

		var req = https.request({
			path,
			method,
			headers
		})

		if (method === 'POST') {
			req.write(postBody)
		}

		req.on("response", function(response) {
			let body = ""

			response.on('data', function(chunk) {
				body += chunk
			})

			response.on("end", function() {
				try {
					if (response.statusCode < 400) {
						if (body.length === 0) {
							resolve({status: response.statusCode, message:response.statusMessage})
						} else {
							resolve(JSON.parse(body))
						}
					} else {
						reject(new Error(response.statusMessage))
					}

				} catch(ex) {
					reject(ex)
				}
			})
		})

		req.on('error', function(e) {
			reject(e)
		})

		req.end()

		return req
	})
}

export default {
	authenticate(user, password) {
		var postBody = JSON.stringify({
			user,
			password
		})

		return handleRequest('/authenticate/login', 'POST', postBody)
	},

	checkToken() {
		return handleRequest('/authenticate/checkToken', 'GET')
	}
}