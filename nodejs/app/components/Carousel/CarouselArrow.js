import React, { PropTypes } from 'react'

function CarouselArrow(props) {
	const {
		width,
		height,
		fill,
		dir,
		backColor,
		containerClass,
		arrowClass,
	} = props

	const rotation = dir === 'right' ? 0 : 180
	const container = containerClass || `slick-arrow-${dir}-container`
	const arrow = arrowClass || `slick-arrow-${dir}`

	let style = null
		// if background color was passed, set it, else no background (standard carousel)
	if (backColor !== null) {
		style = { display: 'flex', backgroundImage: `linear-gradient(${1 * rotation + 90}deg, rgba(0,0,0,0.00) 0%, ${backColor} 100%)` }
	} else {
		style = { display: 'flex' }
	}

	const classes = `vertical-center ${container}`

	return (
		<div {...props} className={classes} style={style} onMouseOver="">
			<svg className={arrow} width={width} height={height} viewBox="12 863 25 36" version="1.1" xmlns="http://www.w3.org/2000/svg">
				<g stroke="none" strokeWidth="1" fill="none" fillRule="evenodd" transform={`translate(24.000000, 883.500000) rotate(${rotation}) translate(-24.000000, -883.500000) translate(17.000000, 871.000000)`}>
					<polygon fill={fill} points="0.0194872683 1.30359212 1.26844401 0 13.6363636 12.5 1.25309041 25 0 23.6927097 11.0108971 12.5" />
				</g>
			</svg>
		</div>
	)
}

CarouselArrow.propTypes = {
	width: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
	height: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
	fill: PropTypes.string,
	dir: PropTypes.string,
	backColor: PropTypes.string,
	containerClass: PropTypes.string,
	arrowClass: PropTypes.string,
}

CarouselArrow.defaultProps = {
	width: 40,
	height: 40,
	fill: 'white',
	dir: 'right',
	backColor: null,
	containerClass: null,
	arrowClass: null,
}

export default CarouselArrow
