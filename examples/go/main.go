package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"
)

type User struct {
	ID        string `json:"id"`
	Email     string `json:"email"`
	Name      string `json:"name"`
	CreatedAt string `json:"created_at"`
	Active    bool   `json:"active"`
}

type UsersHandler struct {
	users map[string]User
}

func NewUsersHandler() *UsersHandler {
	return &UsersHandler{users: make(map[string]User)}
}

func (h *UsersHandler) ListUsers(w http.ResponseWriter, r *http.Request) {
	users := make([]User, 0, len(h.users))
	for _, user := range h.users {
		users = append(users, user)
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]interface{}{"users": users, "count": len(users)})
}

func (h *UsersHandler) GetUser(w http.ResponseWriter, r *http.Request) {
	id := r.URL.Query().Get("id")
	if id == "" {
		http.Error(w, "missing user id", http.StatusBadRequest)
		return
	}
	user, exists := h.users[id]
	if !exists {
		http.Error(w, "user not found", http.StatusNotFound)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(user)
}

func (h *UsersHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}
	var user User
	if err := json.NewDecoder(r.Body).Decode(&user); err != nil {
		http.Error(w, "invalid request body", http.StatusBadRequest)
		return
	}
	if user.Email == "" || user.Name == "" {
		http.Error(w, "email and name required", http.StatusBadRequest)
		return
	}
	user.ID = fmt.Sprintf("usr_%d", time.Now().UnixNano())
	user.CreatedAt = time.Now().Format(time.RFC3339)
	user.Active = true
	h.users[user.ID] = user
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(user)
}

func main() {
	users := NewUsersHandler()
	users.users["usr_1"] = User{ID: "usr_1", Email: "alice@example.com", Name: "Alice Johnson", CreatedAt: time.Now().Add(-24 * time.Hour).Format(time.RFC3339), Active: true}
	users.users["usr_2"] = User{ID: "usr_2", Email: "bob@example.com", Name: "Bob Smith", CreatedAt: time.Now().Add(-48 * time.Hour).Format(time.RFC3339), Active: true}

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		json.NewEncoder(w).Encode(map[string]string{"status": "healthy", "time": time.Now().Format(time.RFC3339)})
	})
	http.HandleFunc("/users", users.ListUsers)
	http.HandleFunc("/user", users.GetUser)
	http.HandleFunc("/user/create", users.CreateUser)

	fmt.Println("User service starting on :8080")
	fmt.Println("Endpoints: /health, /users, /user?id=X, /user/create (POST)")
	http.ListenAndServe(":8080", nil)
}
