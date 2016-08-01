import 'babel-polyfill'
import React from 'react'
import { Router } from 'react-router'
import { render } from 'react-dom'
import { Provider } from 'react-redux'
import configureStore from './store/configureStore'
import { browserHistory } from 'react-router'
import createLogger from 'redux-logger'
import getRoutes from './routes'
import defaultState from './defaultState'
import EventActionCreators from './features/EventEdit/features/details/actions/creators'
import PlanDiscoveryActionCreators from './features/PlanDiscovery/actions/creators'
import { addLocaleData, IntlProvider } from 'react-intl'
import moment from 'moment'
import ga from 'react-ga'

ga.initialize('UA-3571547-125', {'language': window.__LOCALE__.locale});

if (typeof window !== 'undefined') {
	window.__GA__ = ga;
}

require('moment/min/locales')

let initialState = defaultState

if (typeof window !== 'undefined' && typeof window.__INITIAL_STATE__ !== 'undefined') {
	initialState = window.__INITIAL_STATE__
}

let logger = null
if (typeof window !== 'undefined' && typeof window.__ENV__ !== 'undefined' && window.__ENV__ !== 'production') {
	logger = createLogger()
}

const store = configureStore(initialState, browserHistory, logger)

function requireAuth(nextState, replace) {
	const state = store.getState()
	if (!state.auth.isLoggedIn && nextState.location.pathname !== '/' + window.__LOCALE__.locale + '/login') {
		replace({
			pathname: '/' + window.__LOCALE__.locale + '/login',
			state: { nextPathname: nextState.location.pathname }
		})
	}
}

function requireEvent(nextState, replace, callback) {
	const { params } = nextState
	if (params.hasOwnProperty("id") && params.id > 0) {
		store.dispatch(EventActionCreators.view(params.id, store.getState().auth.isLoggedIn)).then((event) => {
			callback()
		}, (error) => {
			callback()
		})
	} else {
		store.dispatch(EventActionCreators.new())
		callback()
	}
}

// auth?
function requirePlanDiscoveryData(nextState, replace, callback) {
	store.dispatch(PlanDiscoveryActionCreators.discoverAll({ language_tag: 'en' }, false)).then((event) => {
		callback()
	}, (error) => {
		callback()
	})
}

function requirePlanCollectionData(nextState, replace, callback) {
	const { params } = nextState
	if (params.hasOwnProperty("id") && params.id > 0) {
		store.dispatch(PlanDiscoveryActionCreators.collectionAll({ id: params.id }, false)).then((event) => {
			callback()
		}, (error) => {
			callback()
		})
	} else {
		callback()
	}
}

function logPageView() {
	if (typeof window !== 'undefined') {
  	window.__GA__.pageview(window.location.pathname);
  }
}

const routes = getRoutes(requireAuth, requireEvent, requirePlanDiscoveryData, requirePlanCollectionData)
addLocaleData(window.__LOCALE__.data)
moment.locale(window.__LOCALE__.momentLocale)
window.__LOCALE__.momentLocaleData = moment.localeData()

render(
	<IntlProvider locale={window.__LOCALE__.locale} messages={window.__LOCALE__.messages}>
		<Provider store={store}>
			<Router routes={routes} history={browserHistory}  onUpdate={logPageView} />
		</Provider>
	</IntlProvider>,
  document.getElementById('react-app')
)
