// 1. Basics
console.log("Welcome to the Community Portal");
window.onload = () => alert("Page Loaded");

// 2. Data Types
const eventName = "Music Fest";
const eventDate = "2025-07-01";
let seats = 5;

console.log(`Event: ${eventName} on ${eventDate}`);

// 5. Class (Objects & Prototype)
class Event {
    constructor(name, category, date, seats) {
        this.name = name;
        this.category = category;
        this.date = date;
        this.seats = seats;
    }

    checkAvailability() {
        return this.seats > 0;
    }
}

// 6. Array
let events = [
    new Event("Music Fest", "music", "2025-07-01", 5),
    new Event("Tech Talk", "tech", "2025-06-01", 0),
    new Event("Baking Workshop", "food", "2025-08-01", 10)
];

// 4. Functions
function addEvent(event) {
    events.push(event);
}

function registerUser(eventObj) {
    try {
        if (eventObj.seats <= 0) throw "No seats available";
        eventObj.seats--;
        console.log("Registered!");
    } catch (err) {
        console.error(err);
    }
}

// Closure
function registrationCounter() {
    let count = 0;
    return function () {
        count++;
        return count;
    };
}
const countReg = registrationCounter();

// 7. DOM Manipulation
const container = document.querySelector("#events");

function displayEvents(list) {
    container.innerHTML = "";
    list.forEach(e => {
        if (new Date(e.date) < new Date() || e.seats <= 0) return;

        let div = document.createElement("div");
        div.innerHTML = `
            <h3>${e.name}</h3>
            <p>${e.category}</p>
            <p>Seats: ${e.seats}</p>
            <button onclick="handleRegister('${e.name}')">Register</button>
        `;
        container.appendChild(div);
    });
}

// Register handler
function handleRegister(name) {
    let eventObj = events.find(e => e.name === name);
    registerUser(eventObj);
    displayEvents(events);
}

// 8. Event Handling
document.querySelector("#categoryFilter").onchange = (e) => {
    let value = e.target.value;
    let filtered = value === "all" ? events : events.filter(ev => ev.category === value);
    displayEvents(filtered);
};

document.querySelector("#search").addEventListener("keydown", (e) => {
    let text = e.target.value.toLowerCase();
    let filtered = events.filter(ev => ev.name.toLowerCase().includes(text));
    displayEvents(filtered);
});

// 10. Modern JS
function filterEventsByCategory(cat = "all") {
    let copy = [...events];
    return cat === "all" ? copy : copy.filter(e => e.category === cat);
}

// 9. Async / Fetch
function fetchEvents() {
    console.log("Loading...");
    return new Promise((resolve) => {
        setTimeout(() => resolve(events), 1000);
    });
}

async function loadEvents() {
    let data = await fetchEvents();
    displayEvents(data);
}
loadEvents();

// 11. Forms
document.querySelector("#registerForm").addEventListener("submit", (e) => {
    e.preventDefault();

    let form = e.target;
    let name = form.elements["name"].value;
    let email = form.elements["email"].value;

    if (!name || !email) {
        alert("Fill all fields");
        return;
    }

    console.log("User:", name, email);
});

// 12. AJAX (Mock POST)
function sendData() {
    fetch("https://jsonplaceholder.typicode.com/posts", {
        method: "POST",
        body: JSON.stringify({ name: "User" }),
        headers: { "Content-type": "application/json" }
    })
    .then(res => res.json())
    .then(data => console.log("Success:", data))
    .catch(err => console.error(err));
}

// 13. Debugging
console.log("Debug: Events loaded", events);

// 14. jQuery (optional if added)
if (window.$) {
    $("#registerBtn").click(() => {
        $("#events").fadeOut().fadeIn();
    });
}