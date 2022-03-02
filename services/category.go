package services

var categories map[string]Category

type Category struct {
	// Example: Gateways and terminal sharing
	Name string
	// Example: gateways-and-terminal-sharing
	Slug string
}

func GetCategories() map[string]Category {
	categories = make(map[string]Category)

	categories["gateways-and-terminal-sharing"] = Category{"Gateways and terminal sharing", "gateways-and-terminal-sharing"}
	categories["misc-other"] = Category{"Misc/Other", "misc-other"}

	return categories
}

func GetCategory(serviceSlug string) Category {
	return GetCategories()[serviceSlug]
}
