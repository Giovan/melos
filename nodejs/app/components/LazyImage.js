import React, { Component, PropTypes } from 'react'

class LazyImage extends Component {

	constructor(props) {
		super(props)
		this.state = {
			loaded: false
		}
	}

	render() {
		const {
			placeholder,
			src,
			width,
			height,
			customClass,
			imgClass,
			alt,
			crossOrigin
		} = this.props
		const { loaded } = this.state

		return (
			<div
				className={`placeholder ${customClass}`}
				style={{
					width: typeof width === 'string' ? width : `${width}px`,
					height: typeof height === 'string' ? height : `${height}px`,
				}}
			>
				{ placeholder }
				<img
					alt={alt}
					src={src}
					width={width}
					height={height}
					crossOrigin={crossOrigin}
					className={`large ${loaded ? 'loaded' : ''} ${imgClass}`}
					onLoad={() => { this.setState(() => { return { loaded: true } }) }}
				/>
			</div>
		)
	}
}

LazyImage.propTypes = {
	placeholder: PropTypes.oneOfType([PropTypes.node, PropTypes.string]),
	src: PropTypes.string,
	alt: PropTypes.string,
	customClass: PropTypes.string,
	imgClass: PropTypes.string,
	width: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
	height: PropTypes.oneOfType([PropTypes.number, PropTypes.string]),
	crossOrigin: PropTypes.string
}

LazyImage.defaultProps = {
	placeholder: null,
	src: '',
	alt: '',
	customClass: '',
	imgClass: '',
	width: '100%',
	height: '100%',
	crossOrigin: null
}

export default LazyImage
