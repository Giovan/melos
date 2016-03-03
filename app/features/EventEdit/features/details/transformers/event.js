import { fromApiFormat as contentFromApiFormat } from '../../content/transformers/content'
import arrayToObject from '../../../../../lib/arrayToObject'

export function fromApiFormat(event) {
	let { item } = event

	if (typeof item !== 'object') {
		item = {}
	}

	if (!Array.isArray(item.content)) {
		item.content = []
	}

	let content = item.content.map((c) => {
		return contentFromApiFormat(Object.assign({}, c, { content_id: c.id, id: item.id }))
	})

	let locations = arrayToObject(item.locations.map((l) => {
		l.isSelected = true
		l.times = Array.isArray(l.times) ? l.times : []
		return l
	}), 'id')

	content = sortContent(content)

	return Object.assign({}, event, { item: { ...item, content, locations }})
}

export function sortContent(content) {
	content.sort((a,b) => {
		if (a.sort < b.sort) {
			return -1
		} else if (a.sort > b.sort) {
			return 1
		} else if (a.sort === b.sort) {
			if (a.content_id < b.content_id) {
				return -1
			} else if (a.content_id > b.content_id) {
				return 1
			} else if (a.content_id === b.content_id) {
				return 0
			}
		}
	})

	return content.map((c,i) => {
		c.sort = i * 100
		return c
	})
}
