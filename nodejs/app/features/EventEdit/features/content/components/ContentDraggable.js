import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Row from '../../../../../../app/components/Row'
import { DragSource, DropTarget } from 'react-dnd'
import { findDOMNode } from 'react-dom'
import ReorderGrayImage from '../../../../../../images/reorder-gray.png'

const contentSource = {
	beginDrag(props) {
		return {
			...props
		}
	}
}

const contentTarget = {
	hover(props, monitor, component) {
		const { handleMove } = props
		const dragIndex = monitor.getItem().contentIndex
		const hoverIndex = props.contentIndex

		if (dragIndex === hoverIndex) {
			return
		}

		const hoverBoundingRect = findDOMNode(component).getBoundingClientRect()
		const hoverMiddleY = (hoverBoundingRect.bottom - hoverBoundingRect.top) / 2
		const clientOffset = monitor.getClientOffset()
		const hoverClientY = clientOffset.y - hoverBoundingRect.top

		if (dragIndex < hoverIndex && hoverClientY < hoverMiddleY) {
			return
		}

		if (dragIndex > hoverIndex && hoverClientY > hoverMiddleY) {
			return
		}

		handleMove(dragIndex, hoverIndex)
		monitor.getItem().contentIndex = hoverIndex
	}
}

class ContentDraggable extends Component {
	render() {
		const { contentIndex, content, connectDragSource, connectDropTarget, isDragging, intl } = this.props

		let style = {}
		if (isDragging) {
			style = {
				opacity: 0
			}
		}

		let previewText = ''
		switch (content.type) {
			case 'text':
				previewText = content.data.body.replace(/(<([^>]+)>)/ig, '').substr(0, 80)
				break;

			case 'announcement':
				previewText = content.data.title.substr(0, 80)
				break;

			case 'reference':
				previewText = content.data.human
				break;

			case 'plan':
				previewText = content.data.title
				break;

			case 'url':
				previewText = content.data.url
				break;

			case 'image':
				previewText = content.data.url
				break;
		}

		let contentTypeLabel = null
		if (content.type === 'url') {
			if (content.hasOwnProperty('iamagivinglink') && content.iamagivinglink) {
				contentTypeLabel = intl.formatMessage({ id: 'features.EventEdit.features.content.components.ContentHeader.giving' })
			} else {
				contentTypeLabel = intl.formatMessage({ id: 'features.EventEdit.features.content.components.ContentHeader.link' })
			}
			contentTypeLabel = intl.formatMessage({ id: 'features.EventEdit.features.content.components.ContentHeader.link' })
		} else {
			contentTypeLabel = intl.formatMessage({ id: `features.EventEdit.features.content.components.ContentHeader.${content.type.toLowerCase()}` })
		}

		return connectDragSource(connectDropTarget(
			<div className='content-draggable' style={style}>
				<Row>
					<div className='medium-12'>
						<div className='sort'>
							{contentIndex + 1}
						</div>
						<div className='body'>
							<div className='type'>
								{contentTypeLabel}
							</div>
							<div className='preview'>
								{previewText}
							</div>
							<img className='dragHandle' src={ReorderGrayImage} />
						</div>
					</div>
				</Row>
			</div>
			))
	}
}

export default DropTarget('content', contentTarget, connect => {
	return ({
		connectDropTarget: connect.dropTarget()
	})
})(DragSource('content', contentSource, (connect, monitor) => {
	return ({
		connectDragSource: connect.dragSource(),
		isDragging: monitor.isDragging()
	})
})(ContentDraggable))
