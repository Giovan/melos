import React, { Component, PropTypes } from 'react'
import { FormattedMessage, injectIntl } from 'react-intl'
import { Link } from 'react-router'
import Helmet from 'react-helmet'

import CarouselStandard from '../../../components/Carousel/CarouselStandard'
import Image from '../../../components/Carousel/Image'
import PlanActionButtons from './PlanActionButtons'
import AvatarList from '../../../components/AvatarList'
import ShareWidget from './ShareWidget'
import imageUtil from '../../../lib/imageUtil'
import Routes from '../../../lib/routes'


class AboutPlan extends Component {
	constructor(props) {
		super(props)
		this.state = { dialogOpen: false }
	}

	handleClick() {
		this.setState({ dialogOpen: !this.state.dialogOpen })
	}

	render() {
		const { readingPlan, savedPlans, recommendedPlans, serverLanguageTag, imageConfig, auth, localizedLink, isRtl, params } = this.props

		if (!readingPlan || (typeof readingPlan === 'object' && readingPlan.__validation && !readingPlan.__validation.isValid)) {
			return (
				<div />
			)
		}

		const aboutLink = localizedLink(`/reading-plans/${readingPlan.id}-${readingPlan.slug}`)
		const subLinkBase = localizedLink(`/users/${auth.userData.username}/reading-plans/${readingPlan.id}-${readingPlan.slug}`)
		const isSaved = !!((savedPlans && Array.isArray(savedPlans.all) && savedPlans.all.indexOf(readingPlan.id) !== -1))
		const recommended = (recommendedPlans && recommendedPlans[readingPlan.id]) ? recommendedPlans[readingPlan.id] : null
		let friendsReading, friendsCompleted, readingList, completedList, relatedCarousel = null
		const publisherLink = (readingPlan.publisher_url) ? <a className='publisher' href={readingPlan.publisher_url}><FormattedMessage id='plans.about publisher' /></a> : null
		const languageTag = serverLanguageTag || params.lang || auth.userData.language_tag || 'en'

		if (recommended) {
			relatedCarousel = (
				<div className='row collapse'>
					<CarouselStandard carouselContent={recommended} context='recommended' imageConfig={imageConfig} localizedLink={localizedLink} isRtl={isRtl} />
				</div>
			)
		}

		const milestones = [0, 1000, 2500, 5000, 7500, 10000, 25000, 50000, 75000, 100000, 250000, 500000, 750000]
		let completedMilestone = 0

		if (readingPlan.stats) {
			if (
				(typeof readingPlan.stats.friends !== 'undefined') &&
				(readingPlan.stats.friends !== null) &&
				(readingList = readingPlan.stats.friends.subscribed)
			) {
				const readingText = (readingList.length === 1) ? <FormattedMessage id='plans.stats.friends reading.one' values={{ count: readingPlan.stats.friends.subscribed.length }} /> : <FormattedMessage id='plans.stats.friends reading.other' values={{ count: readingPlan.stats.friends.subscribed.length }} />
				friendsReading = (
					<div>
						<p className='friends_completed'>{ readingText }</p>
						<AvatarList avatarList={readingList} />
					</div>
				)
			}

			if (readingPlan.stats.friends && (completedList = readingPlan.stats.friends.completed)) {
				const completedText = (completedList.length === 1) ? <FormattedMessage id='plans.stats.friends completed.one' values={{ count: readingPlan.stats.friends.completed.length }} /> : <FormattedMessage id='plans.stats.friends completed.other' values={{ count: readingPlan.stats.friends.completed.length }} />
				friendsCompleted = (
					<div>
						<p className='friends_completed'>{ completedText }</p>
						<AvatarList avatarList={completedList} />
					</div>
				)
			}


			milestones.forEach((milestone) => {
				if (readingPlan.stats.total_completed > milestone && milestone > completedMilestone) {
					completedMilestone = milestone
				}
			})
		}


		const readingPlansStats = (completedMilestone !== 0) ?
			<p className='friends_completed'><FormattedMessage id='plans.stats.total completions' values={{ count: completedMilestone }} /></p> :
			null

		const selectedImage = imageUtil(360, 640, false, 'about_plan', readingPlan, false)
		const url = `https://www.bible.com/reading-plans/${readingPlan.id}-${readingPlan.slug}`
		const planLinkNode = <Link to={`${aboutLink}/day/1`}><FormattedMessage id='plans.sample' /></Link>

		return (
			<div className='row collapse about-plan horizontal-center'>
				<Helmet
					title={`${readingPlan.name[languageTag] || readingPlan.name.default} - ${readingPlan.about.text[languageTag] || readingPlan.about.text.default}`}
					meta={[
						{ name: 'description', content: readingPlan.about.text[languageTag] || readingPlan.about.text.default },
						{ name: 'og:image', content: `https:${selectedImage.url}` },
						{ name: 'og:title', content: `${readingPlan.name[languageTag] || readingPlan.name.default}` },
						{ name: 'og:url', content: url },
						{ name: 'og:description', content: `${readingPlan.about.text[languageTag] || readingPlan.about.text.default}` },
						{ name: 'twitter:image', content: `https:${selectedImage.url}` },
						{ name: 'twitter:card', content: 'summary' },
						{ name: 'twitter:url', content: url },
						{ name: 'twitter:title', content: `${readingPlan.name[languageTag] || readingPlan.name.default}` },
						{ name: 'twitter:description', content: `${readingPlan.about.text[languageTag] || readingPlan.about.text.default}` },
						{ name: 'twitter:site', content: '@YouVersion' },
						{ name: 'og:image:width', content: selectedImage.width },
						{ name: 'og:image:height', content: selectedImage.height }
					]}
				/>
				<div className='large-8 medium-8 small-11'>
					<div className='reading_plan_index_header'>
						<Link className='plans' to={localizedLink('/reading-plans')}>&larr;<FormattedMessage id='plans.plans' /></Link>
						<div className='right'>
							<ShareWidget />
						</div>
					</div>
					<article className='reading_plan_index'>
						<div className='plan-image'>
							<Image className='rp-hero-img' width={720} height={400} thumbnail={false} imageId='false' type='about_plan' config={readingPlan} />
						</div>
						<div className='row collapse'>
							<div className='columns large-8 medium-8'>
								<h1>{ readingPlan.name[languageTag] || readingPlan.name.default }</h1>
								<p className='plan_length'>{ readingPlan.formatted_length[languageTag] || readingPlan.formatted_length.default}</p>
								<p className='plan_about'>{ readingPlan.about.text[languageTag] || readingPlan.about.text.default }</p>
								<h3 className='publisher'><FormattedMessage id='plans.publisher' /></h3>
								<p className='publisher'>{ readingPlan.copyright.text[languageTag] || readingPlan.copyright.text.default }</p>
								{ publisherLink }
							</div>
							<div className='columns large-4 medium-4'>
								<div className='side-col'>
									<PlanActionButtons
										id={readingPlan.id}
										aboutLink={aboutLink}
										subLinkBase={subLinkBase}
										planLinkNode={planLinkNode}
										isSubscribed={'subscription_id' in readingPlan}
										isSaved={isSaved}
									/>
									<hr />
									<div className='widget'>
										{ friendsReading }
										{ friendsCompleted }
										{ readingPlansStats }
									</div>
								</div>
							</div>
						</div>
						<hr className='hide-for-small' />
						{ relatedCarousel }
					</article>
				</div>
			</div>
		)
	}
}

AboutPlan.propTypes = {
	readingPlan: PropTypes.object,
	recommendedPlans: PropTypes.object,
	imageConfig: PropTypes.object,
	auth: PropTypes.object,
	localizedLink: PropTypes.func,
	isRtl: PropTypes.func,
	params: PropTypes.object,
	serverLanguageTag: PropTypes.string,
	savedPlans: PropTypes.object
}

export default injectIntl(AboutPlan)
