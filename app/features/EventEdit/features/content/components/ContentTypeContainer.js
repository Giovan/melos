import React, { Component, PropTypes } from 'react'
import Row from '../../../../../../app/components/Row'
import Column from '../../../../../../app/components/Column'
import ContentTypeText from './ContentTypeText'
import ContentTypeAnnouncement from './ContentTypeAnnouncement'

const AUTO_SAVE_TIMEOUT = 5000

class ContentTypeContainer extends Component {

	constructor(props) {
		super(props)
		this.cancelSave = null
	}

	handleUpdateClick() {
		const { content, contentIndex, handleUpdate } = this.props
		if (content.isDirty) {
			handleUpdate(contentIndex, content)
		}
	}

	handleChange(changeEvent) {		
		if (typeof changeEvent.target === 'object') {
			const { contentIndex, handleChange } = this.props
			const { name, value } = changeEvent.target
			handleChange(contentIndex, name, value)
		}

		this.autoSave()
	}

	handleRemove(removeEvent) {
		const { contentIndex, content, handleRemove } = this.props
		handleRemove(contentIndex, content.content_id)
	}

	autoSave() {
		const { content, handleUpdate } = this.props

		if (typeof this.cancelSave === 'number') {
			clearTimeout(this.cancelSave)
			this.cancelSave = null
		}

		this.cancelSave = setTimeout(::this.handleUpdateClick, AUTO_SAVE_TIMEOUT)
	}

	render() {
		const { content } = this.props

		let InnerContainer = null
		switch (content.type) {
			case 'text':
				InnerContainer = (<ContentTypeText handleChange={::this.handleChange} contentData={content.data} />)
				break

			case 'announcement':
				InnerContainer = (<ContentTypeAnnouncement handleChange={::this.handleChange} contentData={content.data} />)
				break

			case 'reference':
			case 'plan':
			case 'url':
			case 'image':
			
			default:
				break
		}

		return (
			<div className='content-type-text'>
				<Row>
					<div className='medium-10 large-8 columns small-centered'>
						{content.type.toUpperCase()} <span className='right'><img src='/images/thin-x.png' /></span>
						<div className='form-body'>
							{InnerContainer}
							{ content.isDirty ? 'D' : '.'}
							{ content.isSaving ? 'Saving...' : '.'}
						</div>
					</div>
				</Row>
			</div>
		)
	}

}

ContentTypeContainer.propTypes = {

}

export default ContentTypeContainer