import React, { PropTypes, Component } from 'react'
import { connect } from 'react-redux'
import { FormattedMessage, injectIntl } from 'react-intl'
import withTopicData from '@youversion/api-redux/lib/endpoints/explore/hocs/withTopic'
import Card from '@youversion/melos/dist/components/containers/Card'
import Heading1 from '@youversion/melos/dist/components/typography/Heading1'
import Heading2 from '@youversion/melos/dist/components/typography/Heading2'
import wrapWordsInTag from '@youversion/utils/lib/text/wrapWordsInTag'
import VerticalSpace from '@youversion/melos/dist/components/layouts/VerticalSpace'
import TopicList from '../../features/Explore/TopicList'
import ShareSheet from '../../widgets/ShareSheet/ShareSheet'
import VerseImagesSlider from '../../widgets/VerseImagesSlider'
import ReferenceContent from '../Bible/components/content/ReferenceContent'
import List from '../../components/List'

export const ABOVE_THE_FOLD = 3

class TopicView extends Component {

	constructor(props) {
		super(props)
		this.state = {
			showAll: false,
		}
	}

	showAll = () => {
		const { showAll } = this.state
		if (!showAll) {
			this.setState({ showAll: true })
		}
	}

	render() {
		const { usfmsForTopic, topic } = this.props
		const { showAll } = this.state

		const list = showAll
			? usfmsForTopic
			: usfmsForTopic.slice(0, ABOVE_THE_FOLD)
		return (
			<div>
				<div style={{ width: '100%', marginBottom: '25px' }}>
					<Heading1>
						<FormattedMessage id={topic} />
					</Heading1>
				</div>
				<div className='gray-background horizontal-center flex-wrap' style={{ padding: '50px 0 100px 0' }}>
					{/* <Helmet
							title={title}
							meta={[
							{ name: 'description', content: verse },
							{ property: 'og:title', content: title },
							{ property: 'og:url', content: url },
							{ property: 'og:description', content: verse },
							{ name: 'twitter:card', content: 'summary' },
							{ name: 'twitter:url', content: url },
							{ name: 'twitter:title', content: title },
							{ name: 'twitter:description', content: verse },
							{ name: 'twitter:site', content: '@YouVersion' },
						]}
					/> */}
					<div className='yv-large-5 yv-medium-7 yv-small-11 votd-view' style={{ width: '100%' }}>
						<VerticalSpace space={40}>
							<Card padding='none'>
								<List
									loadMore={!showAll && this.showAll}
									pageOnScroll={false}
									loadButton={<div className='card-button'><FormattedMessage id='more' /></div>}
								>
									{
										list.map((usfm) => {
											return (
												<div key={usfm} style={{ borderBottom: '2px solid #F4F4F4', padding: '35px 25px' }}>
													<VerticalSpace>
														<ReferenceContent
															usfm={usfm}
															processContent={(content) => {
																return wrapWordsInTag({ text: content, tag: 'strong', words: [topic] })
															}}
														/>
														<VerseImagesSlider
															usfm={usfm}
															category='prerendered'
															imgWidth={200}
															imgHeight={200}
														/>
													</VerticalSpace>
												</div>
											)
										})
									}
								</List>
							</Card>
							<Card>
								<div style={{ marginBottom: '25px' }}>
									<Heading2>What does the Bible say about...</Heading2>
								</div>
								<TopicList />
							</Card>
						</VerticalSpace>
					</div>
					<ShareSheet />
				</div>
			</div>
		)
	}
}

TopicView.propTypes = {
	moments: PropTypes.object,
	routeParams: PropTypes.object.isRequired,
	serverLanguageTag: PropTypes.string,
	bible: PropTypes.object,
	intl: PropTypes.object.isRequired,
	hosts: PropTypes.object.isRequired,
	dispatch: PropTypes.func.isRequired,
}

TopicView.defaultProps = {
	moments: null,
	bible: null,
	serverLanguageTag: 'en',
}

function mapStateToProps(state) {
	return {
		serverLanguageTag: state.serverLanguageTag,
		hosts: state.hosts,
	}
}

export default connect(mapStateToProps, null)(injectIntl(withTopicData(TopicView)))
