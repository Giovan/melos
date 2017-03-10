import type from './constants'

const ActionCreators = {

	handleInvalidReference(params, auth) {
		const { version } = params

		const fallbackParams = {
			isInitialLoad: false,
			hasVersionChanged: true,
			hasChapterChanged: true,
			language_tag: 'en',
			version: '1',
			reference: 'JHN.1',
			showError: true,
		}

		// if we're handling a reference error, let's grab the first valid
		// chapter from the new version and set the bible up that way
		return dispatch => {
			return new Promise((resolve) => {
				dispatch(ActionCreators.bibleVersion({ id: version })).then((newVersion) => {
					const newRef = newVersion.books[0].chapters[0].usfm
					dispatch(ActionCreators.readerLoad(Object.assign({}, params, { hasVersionChanged: true, hasChapterChanged: true, reference: newRef, showError: true }), auth)).then(() => {
						resolve()
					})
				}, () => {
					resolve(
						dispatch(ActionCreators.readerLoad(fallbackParams, auth))
					)
				})
			})
		}
	},

	/**
	 * @version: VERSION_ID
   * @reference: USFM
   * @lang: locale
	 * @auth: auth
	 * @return Promise
	 */
	readerLoad(params, auth) {
		return dispatch => {
			const { isInitialLoad, hasVersionChanged, hasChapterChanged, version, reference, language_tag } = params
			const showError = params.showError || false

			const promises = []

			if (isInitialLoad) {
				promises.push(
					dispatch(ActionCreators.bibleConfiguration()),
					dispatch(ActionCreators.momentsColors(auth))
				)
			}

			if (isInitialLoad || hasVersionChanged) {
				promises.push(
					new Promise((resolve, reject) => {
						dispatch(ActionCreators.bibleVersion({ id: version })).then((newVersion) => {
							if ('errors' in newVersion) {
								reject(newVersion.errors)
							} else {
								resolve(
									dispatch(ActionCreators.bibleVersions({ language_tag: newVersion.language.language_tag, type: 'all' }))
								)
							}
						})
					})
				)
			}

			if (isInitialLoad || hasChapterChanged) {
				promises.push(
					new Promise((resolve, reject) => {
						dispatch(ActionCreators.bibleChapter({ id: version, reference: reference.toUpperCase() }, { showError })).then((data) => {
							if ('errors' in data) {
								reject(data.errors)
							} else {
								resolve()
							}
						})
					}),
				)
			}

			if (auth && isInitialLoad) {
				promises.push(
					dispatch(ActionCreators.momentsLabels(auth)),
					dispatch(ActionCreators.usersViewSettings(auth))
				)
			}

			if (auth && (isInitialLoad || hasChapterChanged || hasVersionChanged)) {
				promises.push(
					dispatch(ActionCreators.momentsVerseColors(auth, { usfm: reference.toUpperCase(), version_id: version }))
				)
			}

			return Promise.all(promises)
		}
	},

	/**
	 * @id: VERSION_ID
   * @reference: USFM
   * @format: html/text
	 */
	loadVersionAndChapter(params) {
		return dispatch => {
			const { id, reference } = params
			return Promise.all([
				dispatch(ActionCreators.bibleVersion({ id })),
				dispatch(ActionCreators.bibleChapter({ id, reference: reference.toUpperCase() }))
			])
		}
	},


	/**
	 * @language_tag
	 * @type: all/public
	 */
	bibleVersions(params) {
		return {
			params,
			api_call: {
				endpoint: 'bible',
				method: 'versions',
				version: '3.1',
				auth: false,
				params,
				http_method: 'get',
				types: [ type('bibleVersionsRequest'), type('bibleVersionsSuccess'), type('bibleVersionsFailure') ]
			}
		}
	},

	/**
	 * @id: VERSION_ID
	 */
	bibleVersion(params) {
		return {
			params,
			api_call: {
				endpoint: 'bible',
				method: 'version',
				version: '3.1',
				auth: false,
				params,
				http_method: 'get',
				types: [ type('bibleVersionRequest'), type('bibleVersionSuccess'), type('bibleVersionFailure') ]
			}
		}
	},

	/* no params */
	bibleConfiguration(params = {}) {
		return {
			params,
			api_call: {
				endpoint: 'bible',
				method: 'configuration',
				version: '3.1',
				auth: false,
				params,
				http_method: 'get',
				types: [ type('bibleConfigurationRequest'), type('bibleConfigurationSuccess'), type('bibleConfigurationFailure') ]
			}
		}
	},

	/**
	 * @id: VERSION_ID
   * @reference: USFM
   * @format: html/text
	 */
	bibleChapter(params, extras) {
		return {
			params,
			extras,
			api_call: {
				endpoint: 'bible',
				method: 'chapter',
				version: '3.1',
				auth: false,
				params,
				http_method: 'get',
				types: [ type('bibleChapterRequest'), type('bibleChapterSuccess'), type('bibleChapterFailure') ]
			}
		}
	},

	/**
	 * @version_id: VERSION_ID
   * @reference: USFM
	 */
	audioBibleChapter(params) {
		return {
			params,
			api_call: {
				endpoint: 'audio-bible',
				method: 'chapter',
				version: '3.1',
				auth: false,
				params,
				http_method: 'get',
				types: [ type('audiobibleChapterRequest'), type('audiobibleChapterSuccess'), type('audiobibleChapterFailure') ]
			}
		}
	},

	/**
	 * @id 						id of bible version
	 * @references		verse, or range of verses to get
	 * @format				html by default, or text
	 */
	bibleVerses(params) {
		return {
			params,
			api_call: {
				endpoint: 'bible',
				method: 'verses',
				version: '3.1',
				auth: false,
				params,
				http_method: 'get',
				types: [ type('bibleVersesRequest'), type('bibleVersesSuccess'), type('bibleVersesFailure') ]
			}
		}
	},

	/* no params */
	momentsColors(auth, params = {}) {
		return {
			params,
			api_call: {
				endpoint: 'moments',
				method: 'colors',
				version: '3.1',
				auth,
				params,
				http_method: 'get',
				types: [ type('momentsColorsRequest'), type('momentsColorsSuccess'), type('momentsColorsFailure') ]
			}
		}
	},

	usersViewSettings(auth, params = {}) {
		return {
			params,
			api_call: {
				endpoint: 'users',
				method: 'view_settings',
				version: '3.1',
				auth,
				params,
				http_method: 'get',
				types: [ type('usersViewSettingsRequest'), type('usersViewSettingsSuccess'), type('usersViewSettingsFailure') ]
			}
		}
	},

	usersUpdateSettings(auth, params = {}) {
		return {
			params,
			api_call: {
				endpoint: 'users',
				method: 'update_settings',
				version: '3.1',
				auth,
				params,
				http_method: 'post',
				types: [ type('usersUpdateSettingsRequest'), type('usersUpdateSettingsSuccess'), type('usersUpdateSettingsFailure') ]
			}
		}
	},


	/**
	 * See http://developers.youversion.com/api/docs/3.1/sections/moments/create.html
	 * @kind
	 * @references
	 * @color
	 * @title
	 * @content
	 * @labels
	 * @user_status
	 * @image_id
	 * @created_dt
	 */
	momentsCreate(auth, params) {
		return {
			params,
			api_call: {
				endpoint: 'moments',
				method: 'create',
				version: '3.1',
				auth,
				params,
				http_method: 'post',
				types: [ type('momentsCreateRequest'), type('momentsCreateSuccess'), type('momentsCreateFailure') ]
			}
		}
	},

	/* no params */
	momentsLabels(auth, params = {}) {
		return {
			params,
			api_call: {
				endpoint: 'moments',
				method: 'labels',
				version: '3.1',
				auth,
				params,
				http_method: 'get',
				types: [ type('momentsLabelsRequest'), type('momentsLabelsSuccess'), type('momentsLabelsFailure') ]
			}
		}
	},

	/**
	 * @usfm (chapter only)
	 * @version_id
	 */
	momentsVerseColors(auth, params) {
		return {
			params,
			api_call: {
				endpoint: 'moments',
				method: 'verse_colors',
				version: '3.1',
				auth,
				params,
				http_method: 'get',
				types: [ type('momentsVerseColorsRequest'), type('momentsVerseColorsSuccess'), type('momentsVerseColorsFailure') ]
			}
		}
	},

	/**
	 * @usfm	      {string}  usfm of verse to hide color on
	 * @version_id	{int}			version id of the verse
	 */
	hideVerseColors(auth, params) {
		return {
			params,
			api_call: {
				endpoint: 'moments',
				method: 'hide_verse_colors',
				version: '3.1',
				auth,
				params,
				http_method: 'post',
				types: [ type('hideVerseColorsRequest'), type('hideVerseColorsSuccess'), type('hideVerseColorsFailure') ]
			}
		}
	}
}

export default ActionCreators
