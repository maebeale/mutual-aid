export default class {
    constructor(path = '/listing.json?', injectedFetch) {
        !!injectedFetch
            ?
            (this.injectedFetch = injectedFetch) :
            (this.injectedFetch = this.defaultFetch())
        this.path = path
    }
    fetch(filters, fallback = []) {
        return this.injectedFetch(this.path + this.parsedFilters(filters))
            .then((response) => response.json())
            .then((jsonData) => {
                return { data: jsonData }
            })
            .catch((error) => ({ error: error, data: fallback }))
    }
    parsedFilters(filters = []) {
        return filters.map((filter) => '' + filter + '=1').join('&')
    }
    defaultFetch() {
        return typeof window === 'undefined' ? this.noopFetch : (args) => window.fetch(args)
    }
    async noopFetch() {
        return
    }
}