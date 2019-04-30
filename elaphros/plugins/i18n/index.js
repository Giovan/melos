/* eslint-disable prefer-arrow-callback */
const fp = require('fastify-plugin')
const path = require('path')
const i18n = require('i18n')
const fastifyLanguageParser = require('fastify-language-parser')
const getAppLocale = require('../../utils/localization/get-app-locale')
const localeList = require('../../localization/locale-list.json')
const getPathWithoutLocale = require('../../utils/localization/get-path-without-locale')
const jsonAppLocale = require('./json-app-locales')
const getCookieDomainFromRequest = require('../../utils/get-cookie-domain-from-request')

/* i18n Configuration */
const activeLocales = localeList.map((locale) => { return getAppLocale(locale) })

i18n.configure({
  locales: activeLocales,
  directory: path.join(__dirname, '../../locales'),
  defaultLocale: 'en',
  objectNotation: true,
  updateFiles: false
})

module.exports = fp(function configureI18n(fastify, opts, next) {
  fastify.register(fastifyLanguageParser, {
    order: [ 'path' ],
    fallbackLng: 'en',
    supportedLngs: activeLocales
  })

  fastify.use(i18n.init)

  fastify.addHook('preHandler', (req, reply, hookNext) => {
    const urlData = req.urlData()

    function getUrl(hostName, port, urlPath, query) {
      return `//${hostName}${port ? `:${port}` : ''}${urlPath}${query ? `?${query}` : ''}`
    }

    if ('lng' in req.params && req.detectedLng === 'en') {
      const newUrl = getUrl(urlData.host, urlData.port, getPathWithoutLocale(urlData.path), urlData.query)
      reply.redirect(newUrl)
    }

    reply.res.setLocale(req.detectedLng)

    if (req.detectedLng !== 'en') {
      const cookieDomain = getCookieDomainFromRequest(req)
      reply.setCookie('locale', req.detectedLng, {
        domain: cookieDomain,
        path: '/',
        secure: cookieDomain !== 'localhost',
        hostOnly: true
      })
    }

    hookNext()
  })

  fastify.decorateRequest('appLocales', activeLocales)

  fastify.get('/json/app/locales', jsonAppLocale)

  next()
}, {
  name: 'i18n'
})
