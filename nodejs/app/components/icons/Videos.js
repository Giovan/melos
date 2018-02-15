import React from 'react'
import PropTypes from 'prop-types'
import getProportionalSize from '@youversion/utils/lib/images/imageProportions'

function Videos({ width, height, fill, className }) {
	const {
		height: finalHeight,
		width: finalWidth
	} = getProportionalSize({
		defaultHeight: Videos.defaultProps.height,
		defaultWidth: Videos.defaultProps.width,
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
			<path
				fillRule="evenodd"
				stroke="none"
				fill={fill}
				d="M 5,5 L 19,5 C 20.1,5 21,5.9 21,7 L 21,17 C 21,18.1 20.1,19 19,19 L 5,19 C 3.9,19 3,18.1 3,17 L 3,7 3,7 C 3,5.9 3.9,5 5,5 L 5,5 Z M 9.75,15.57 L 15.24,12.43 15.24,12.43 C 15.48,12.3 15.56,11.99 15.43,11.75 15.38,11.67 15.32,11.61 15.24,11.57 L 9.75,8.43 C 9.51,8.29 9.2,8.37 9.06,8.61 9.02,8.69 9,8.77 9,8.86 L 9,15.14 9,15.14 C 9,15.41 9.22,15.64 9.5,15.64 9.59,15.64 9.67,15.62 9.75,15.57 L 9.75,15.57 Z M 9.75,15.57"
			/>
		</svg>
	)
}

Videos.propTypes = {
	width: PropTypes.number,
	height: PropTypes.number,
	fill: PropTypes.string,
	className: PropTypes.string
}

Videos.defaultProps = {
	width: 24,
	height: 24,
	fill: '#444444',
	className: ''
}

export default Videos
