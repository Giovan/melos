import React from 'react'
import { render } from 'react-dom'
import { Router, useRouterHistory } from 'react-router'
import { Provider } from 'react-redux'
import { addLocaleData, IntlProvider } from 'react-intl'
import ga from 'react-ga'
import { createHistory } from 'history'
import { syncHistoryWithStore } from 'react-router-redux'
import createLogger from 'redux-logger'
import configureStore from './store'
import getRoutes from './routes'

import defaultState from './defaultState'

if (typeof window !== 'undefined') {
	ga.initialize('UA-3571547-76', { language: window.__LOCALE__.locale });
}

function logPageView() {
	if (typeof window !== 'undefined') {
		if (window.location.hostname === 'www.bible.com') {
			ga.set({ page: window.location.pathname, location: window.location.href })
			ga.pageview(window.location.pathname);
		}
		window.scrollTo(0, 0)
	}
}

let initialState = defaultState

const browserHistory = useRouterHistory(createHistory)({
	basename: '/'
})

if (typeof window !== 'undefined' && typeof window.Unsubscribe.__INITIAL_STATE__ !== 'undefined') {
	initialState = window.Unsubscribe.__INITIAL_STATE__
}

let logger = null
if (typeof window !== 'undefined' && typeof window.__ENV__ !== 'undefined' && window.__ENV__ !== 'production') {
	logger = createLogger()
}

const store = configureStore(initialState, browserHistory, logger)
const history = syncHistoryWithStore(browserHistory, store)

addLocaleData(window.__LOCALE__.data)

const routes = getRoutes()

render(
	<IntlProvider locale={window.__LOCALE__.locale} messages={window.__LOCALE__.messages}>
		<Provider store={store}>
			<Router routes={routes} history={browserHistory} onUpdate={logPageView} />
		</Provider>
	</IntlProvider>,
  document.getElementById('react-app-Unsubscribe')
)
