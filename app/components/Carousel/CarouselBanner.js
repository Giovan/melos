import React, { Component } from 'react'
import Slider from 'react-slick'
import CarouselSlideGradient from './CarouselSlideGradient'
import CarouselSlideImage from './CarouselSlideImage'
import Image from './Image'
import CarouselArrow from './CarouselArrow'
import { Link } from 'react-router'

class CarouselBanner extends Component {
	render() {
		const { carouselContent, imageConfig, localizedLink } = this.props

    var settings = {
      centerMode: true,
      infinite: true,
      variableWidth: true,
      initialSlide: 0,
      slickGoTo: 0,
			arrows: true,
			prevArrow: <CarouselArrow dir='left' width='30' height='30' backColor='black'/>,
			nextArrow: <CarouselArrow dir='right' width='30' height='30' backColor='black'/>,
      responsive: [ {
      	breakpoint: 524, settings: { arrows: false }
      } ]
    };

		// for banner carousels, we want an image first, if that doesn't exist then we go to gradient, if gradient doesn't exist then just set default plan image
		var slides = carouselContent.items.map( function(slide, index) {

			var slideLink = (slide.type == 'collection') ? localizedLink(`/reading-plans-collection/${slide.id}`) : localizedLink(`/reading-plans/${slide.id}`)

			if (slide.image_id) {
				return (
					<div className='' key={`${carouselContent.id}-${index}`}>
						<Link to={slideLink}>
							<CarouselSlideImage>
								<Image width={720} height={405} thumbnail={false} imageId={slide.image_id} type={slide.type} config={imageConfig} />
							</CarouselSlideImage>
						</Link>
					</div>
				)
			} else if (slide.gradient) {
				return (
					<div className='' key={`${carouselContent.id}-${index}`}>
						<Link to={slideLink}>
							<CarouselSlideGradient gradient={slide.gradient} id={slide.id} title={slide.title}/>
						</Link>
					</div>
				)
			} else {
				return (
					<div className='' key={`${carouselContent.id}-${index}`}>
						<Link to={slideLink}>
							<CarouselSlideImage>
								<Image width={720} height={405} thumbnail={false} imageId='default' type={slide.type} config={imageConfig} />
							</CarouselSlideImage>
						</Link>
					</div>
				)
			}
		})

		return (
			<div className='carousel-banner'>
				<Slider {...settings}>{slides}</Slider>
			</div>
		);
	}
}


export default CarouselBanner
