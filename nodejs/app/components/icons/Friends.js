import React, { PropTypes } from 'react'
import getProportionalSize from '@youversion/utils/lib/images/imageProportions'

function Friends({ width, height, fill, className }) {
	const {
		height: finalHeight,
		width: finalWidth
	} = getProportionalSize({
		defaultHeight: Friends.defaultProps.height,
		defaultWidth: Friends.defaultProps.width,
		newHeight: height,
		newWidth: width
	})

	return (
		<svg
			className={className}
			width={finalWidth}
			height={finalHeight}
			viewBox="0 0 24 24"
			version="1.1"
			xmlns="http://www.w3.org/2000/svg"
			fillRule="evenodd"
		>
			<g fill="none" fillRule="evenodd">
				<path d="M0 0h24v24H0z" />
				<path
					fill={fill}
					d="M17.108 10.661s-.427 2.564-3.262 2.527c-2.836-.037-3.207-2.545-3.207-2.545l-.278-1.885s-.333-3.278 2.687-3.717c0 0 .631-.092 1.372 0 .83.102 2.466.274 2.91 2.545 0 0 .093.586.056 1.116-.095 1.362-.278 1.96-.278 1.96zM8.949 12.43s-.287 1.863-2.2 1.836c-1.911-.026-2.162-1.85-2.162-1.85l-.187-1.37s-.225-2.382 1.812-2.702c0 0 .425-.066.925 0 .56.075 1.663.2 1.962 1.85 0 0 .063.426.038.812-.064.99-.188 1.424-.188 1.424zm4.808 1.591c3.925 0 6.26 1.228 7.006 3.682a1 1 0 0 1-.956 1.29L7.884 19a1 1 0 0 1-.972-1.237c.609-2.494 2.89-3.742 6.845-3.742zM6.425 19H3.142a1 1 0 0 1-.935-1.354c.543-1.435 2.158-2.152 4.844-2.152C5.99 16.57 5.429 18.145 6.425 19z"
				/>
			</g>
		</svg>
	)
}

Friends.propTypes = {
	width: PropTypes.number,
	height: PropTypes.number,
	fill: PropTypes.string,
	className: PropTypes.string
}

Friends.defaultProps = {
	width: 24,
	height: 24,
	fill: '#444444',
	className: ''
}

export default Friends
