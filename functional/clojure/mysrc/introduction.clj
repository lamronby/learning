(def visitors (atom #{}))
(defn hello
	"Writes hello message to *out*. Call you by username.
	Knows if you have been here before."
	[username]
	(swap! visitors conj username)
	(str "Hello, " username))
