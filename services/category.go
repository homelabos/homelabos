package services

var categories map[string]Category

type Category struct {
	// Example: Gateways and terminal sharing
	Name string
	// Example: gateways-and-terminal-sharing
	Slug     string
	Services []Service
}

func GetCategories() map[string]Category {
	categories = make(map[string]Category)

	categories["analytics"] = Category{"Analytics", "analytics", nil}
	categories["automation"] = Category{"Automation", "automation", nil}
	categories["blogging-platforms"] = Category{"Blogging Platforms", "blogging-platforms", nil}
	categories["calendaring-and-contacts-management"] = Category{"Calendaring and Contacts Management", "calendaring-and-contacts-management", nil}
	categories["chat"] = Category{"Chat", "chat", nil}
	categories["docker-vm-management"] = Category{"Docker & VM Management", "docker-vm-management", nil}
	categories["document-management"] = Category{"Document Management", "document-management", nil}
	categories["ebooks"] = Category{"E-books", "ebooks", nil}
	categories["email"] = Category{"Email", "email", nil}
	categories["federated-identity-authentication"] = Category{"Federated Identity/Authentication", "federated-identity-authentication", nil}
	categories["feed-readers"] = Category{"Feed Readers", "feed-readers", nil}
	categories["file-sharing-and-synchronization"] = Category{"File Sharing and Synchronization", "file-sharing-and-synchronization", nil}
	categories["games"] = Category{"Games", "games", nil}
	categories["gateways-and-terminal-sharing"] = Category{"Gateways and terminal sharing", "gateways-and-terminal-sharing", nil}
	categories["media-streaming"] = Category{"Media Streaming", "media-streaming", nil}
	categories["misc-other"] = Category{"Misc/Other", "misc-other", nil}
	categories["money-budgeting-and-management"] = Category{"Money, Budgeting and Management", "money-budgeting-and-management", nil}
	categories["monitoring"] = Category{"Monitoring", "monitoring", nil}
	categories["note-taking-and-editor"] = Category{"Note-taking and Editors", "note-taking-and-editor", nil}
	categories["password-managers"] = Category{"Password Managers", "password-managers", nil}
	categories["personal-dashboards"] = Category{"Personal Dashboards", "personal-dashboards", nil}
	categories["photo-and-video-galleries"] = Category{"Photo and Video Galleries", "photo-and-video-galleries", nil}
	categories["read-it-later-lists"] = Category{"Read it Later Lists", "read-it-later-lists", nil}
	categories["social-networking"] = Category{"Social Networking", "social-networking", nil}
	categories["software-development"] = Category{"Software Development", "software-development", nil}
	categories["task-management-to-do-lists"] = Category{"Task management/To-do lists", "task-management-to-do-lists", nil}
	categories["vpn"] = Category{"VPN", "vpn", nil}
	categories["web-servers"] = Category{"Web servers", "web-servers", nil}
	categories["wikis"] = Category{"Wikis", "wikis", nil}

	return categories
}

func GetCategory(categorySlug string) Category {
	return GetCategories()[categorySlug]
}
