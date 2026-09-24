const API_URL = "http://localhost:5000/api";

// ========================================
// REGISTER
// ========================================

const registerForm = document.getElementById("registerForm");

if (registerForm) {

    registerForm.addEventListener("submit", async function (event) {

        event.preventDefault();

        const fullName = document.getElementById("name").value.trim();
        const email = document.getElementById("email").value.trim();
        const phone = document.getElementById("phone").value.trim();
        const password = document.getElementById("password").value;
        const confirmPassword =
            document.getElementById("confirmPassword").value;

        const message = document.getElementById("registerMessage");

        // Check passwords
        if (password !== confirmPassword) {
            message.textContent = "Passwords do not match.";
            message.style.color = "red";
            return;
        }

        // Check phone
        if (!/^\d{10}$/.test(phone)) {
            message.textContent =
                "Please enter a valid 10-digit phone number.";
            message.style.color = "red";
            return;
        }

        message.textContent = "Creating account...";
        message.style.color = "#2563eb";

        try {

            const response = await fetch(
                `${API_URL}/auth/register`,
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json"
                    },

                    body: JSON.stringify({
                        fullName,
                        email,
                        phone,
                        password
                    })
                }
            );

            const data = await response.json();

            if (data.success) {

                message.textContent =
                    "Registration successful! Redirecting to login...";

                message.style.color = "green";

                registerForm.reset();

                setTimeout(() => {
                    window.location.href = "login.html";
                }, 1500);

            } else {

                message.textContent =
                    data.message || "Registration failed.";

                message.style.color = "red";
            }

        } catch (error) {

            console.error("Registration error:", error);

            message.textContent =
                "Unable to connect to server.";

            message.style.color = "red";
        }
    });
}


// ========================================
// GENERAL FRONTEND
// ========================================

document.addEventListener("DOMContentLoaded", () => {

    console.log("Lost & Found frontend loaded successfully.");

});
// ========================================
 // ========================================
 // LOGIN
 // ========================================

 const loginForm = document.getElementById("loginForm");

 if (loginForm) {

     loginForm.addEventListener("submit", async function (event) {

         event.preventDefault();

         const email = document.getElementById("email").value.trim();
         const password = document.getElementById("password").value;
         const selectedRole = document.querySelector('input[name="loginRole"]:checked')?.value;
         const message = document.getElementById("loginMessage");

         message.textContent = "Logging in...";
         message.style.color = "#2563eb";

         try {

             const response = await fetch(
                 `${API_URL}/auth/login`,
                 {
                     method: "POST",

                     headers: {
                         "Content-Type": "application/json"
                     },

                     body: JSON.stringify({
                         email,
                         password
                     })
                 }
             );

             const data = await response.json();

             if (data.success) {

                 if (selectedRole !== data.user.Role) {

                     message.textContent =
                         `This account is registered as ${data.user.Role}. Please select ${data.user.Role}.`;

                     message.style.color = "red";

                     return;
                 }

                 message.textContent = "Login successful!";
                 message.style.color = "green";

                 localStorage.setItem(
                     "loggedInUser",
                     JSON.stringify(data.user)
                 );

                 setTimeout(() => {

                     if (data.user.Role === "Admin") {
                         window.location.href = "admin-dashboard.html";
                     } else {
                         window.location.href = "dashboard.html";
                     }

                 }, 1000);

             } else {

                 message.textContent =
                     data.message || "Login failed.";

                 message.style.color = "red";
             }

         } catch (error) {

             console.error("Login error:", error);

             message.textContent =
                 "Unable to connect to server.";

             message.style.color = "red";
         }
     });
 }

 // ========================================
// DASHBOARD
// ========================================

const userNameElement = document.getElementById("userName");

if (userNameElement) {

    const storedUser = localStorage.getItem("loggedInUser");

    if (!storedUser) {

        // User is not logged in
        window.location.href = "login.html";

    } else {

        const user = JSON.parse(storedUser);

        userNameElement.textContent = user.FullName;
    }
}


// ========================================
// LOGOUT
// ========================================

const logoutBtn = document.getElementById("logoutBtn");
const dashboardLogout = document.getElementById("dashboardLogout");

function logoutUser() {

    localStorage.removeItem("loggedInUser");

    window.location.href = "login.html";
}


if (logoutBtn) {
    logoutBtn.addEventListener("click", function (event) {
        event.preventDefault();
        logoutUser();
    });
}


if (dashboardLogout) {
    dashboardLogout.addEventListener("click", function () {
        logoutUser();
    });
}
// ========================================
// REPORT LOST ITEM
// ========================================

const lostItemForm = document.getElementById("lostItemForm");

if (lostItemForm) {

    lostItemForm.addEventListener("submit", async function (event) {

        event.preventDefault();

        const message = document.getElementById("lostItemMessage");

        // Check logged-in user
        const storedUser = localStorage.getItem("loggedInUser");

        if (!storedUser) {

            message.textContent = "Please login first.";
            message.style.color = "red";

            setTimeout(() => {
                window.location.href = "login.html";
            }, 1000);

            return;
        }

        const user = JSON.parse(storedUser);

        const itemName =
            document.getElementById("itemName").value.trim();

        const category =
            document.getElementById("category").value;

        const location =
            document.getElementById("location").value;

        const color =
            document.getElementById("color").value.trim();

        const brand =
            document.getElementById("brand").value.trim();

        const dateLost =
            document.getElementById("dateLost").value;

        const description =
            document.getElementById("description").value.trim();


        message.textContent = "Submitting lost item...";
        message.style.color = "#2563eb";


        try {

            const response = await fetch(
                `${API_URL}/items/lost`,
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json"
                    },

                    body: JSON.stringify({

                        userID: user.UserID,
                        itemName,
                        category,
                        location,
                        color,
                        brand,
                        dateLost,
                        description

                    })
                }
            );


            const data = await response.json();


            if (data.success) {

                message.textContent =
                    "Lost item reported successfully!";

                message.style.color = "green";

                lostItemForm.reset();

                setTimeout(() => {
                    window.location.href = "dashboard.html";
                }, 1500);

            } else {

                message.textContent =
                    data.message || "Failed to report item.";

                message.style.color = "red";

            }


        } catch (error) {

            console.error(
                "Report lost item error:",
                error
            );

            message.textContent =
                "Unable to connect to server.";

            message.style.color = "red";
        }

    });

}
// ========================================
// REPORT FOUND ITEM
// ========================================

const foundItemForm = document.getElementById("foundItemForm");

if (foundItemForm) {

    foundItemForm.addEventListener("submit", async function (event) {

        event.preventDefault();

        const message =
            document.getElementById("foundItemMessage");

        // Check logged-in user
        const storedUser =
            localStorage.getItem("loggedInUser");

        if (!storedUser) {

            message.textContent =
                "Please login first.";

            message.style.color = "red";

            setTimeout(() => {
                window.location.href = "login.html";
            }, 1000);

            return;
        }

        const user = JSON.parse(storedUser);

        const itemName =
            document.getElementById("foundItemName").value.trim();

        const category =
            document.getElementById("foundCategory").value;

        const location =
            document.getElementById("foundLocation").value;

        const color =
            document.getElementById("foundColor").value.trim();

        const brand =
            document.getElementById("foundBrand").value.trim();

        const dateFound =
            document.getElementById("dateFound").value;

        const description =
            document.getElementById("foundDescription").value.trim();


        message.textContent =
            "Submitting found item...";

        message.style.color = "#2563eb";


        try {

            const response = await fetch(
                `${API_URL}/items/found`,
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json"
                    },

                    body: JSON.stringify({

                        userID: user.UserID,
                        itemName,
                        category,
                        location,
                        color,
                        brand,
                        dateFound,
                        description

                    })
                }
            );


            const data = await response.json();


            if (data.success) {

                message.textContent =
                    "Found item reported successfully!";

                message.style.color = "green";

                foundItemForm.reset();

                setTimeout(() => {
                    window.location.href = "dashboard.html";
                }, 1500);

            } else {

                message.textContent =
                    data.message ||
                    "Failed to report found item.";

                message.style.color = "red";
            }


        } catch (error) {

            console.error(
                "Report found item error:",
                error
            );

            message.textContent =
                "Unable to connect to server.";

            message.style.color = "red";
        }

    });

}
// ========================================
// MY REPORTS
// ========================================

const reportsList = document.getElementById("reportsList");

if (reportsList) {

    const storedUser =
        localStorage.getItem("loggedInUser");

    if (!storedUser) {

        window.location.href = "login.html";

    } else {

        const user = JSON.parse(storedUser);

        loadMyReports(user.UserID);
    }
}


async function loadMyReports(userID) {

    try {

        const response = await fetch(
            `${API_URL}/items/my-reports?userID=${userID}`
        );

        const data = await response.json();

        if (!data.success) {

            reportsList.innerHTML = `
                <div class="error">
                    ${data.message || "Failed to load reports."}
                </div>
            `;

            return;
        }


        if (data.reports.length === 0) {

            reportsList.innerHTML = `
                <div class="empty">
                    You have not reported any items yet.
                </div>
            `;

            return;
        }


        reportsList.innerHTML = "";


        data.reports.forEach(report => {

            const typeClass =
                report.ReportType === "Lost"
                    ? "lost-type"
                    : "found-type";

            const icon =
                report.ReportType === "Lost"
                    ? "&#128230;"
                    : "&#128269;";


            const reportCard = document.createElement("div");

            reportCard.className = "report-item";


            reportCard.innerHTML = `

                <div class="report-top">

                    <div class="report-title">

                        <span>
                            ${icon}
                        </span>

                        <h3>
                            ${report.ItemName}
                        </h3>

                        <span class="report-type ${typeClass}">
                            ${report.ReportType}
                        </span>

                    </div>

                    <span class="status">
                        ${report.Status}
                    </span>

                </div>


                <div class="report-details">

                    <div>
                        <strong>Category:</strong>
                        ${report.CategoryName}
                    </div>

                    <div>
                        <strong>Location:</strong>
                        ${report.LocationName}
                    </div>

                    <div>
                        <strong>Color:</strong>
                        ${report.Color || "Not specified"}
                    </div>

                    <div>
                        <strong>Brand:</strong>
                        ${report.Brand || "Not specified"}
                    </div>

                    <div>
                        <strong>Date:</strong>
                        ${report.ReportDate}
                    </div>

                </div>


                ${
                    report.Description
                        ? `
                        <div class="report-description">
                            <strong>Description:</strong>
                            ${report.Description}
                        </div>
                        `
                        : ""
                }

            `;


            reportsList.appendChild(reportCard);

        });


    } catch (error) {

        console.error(
            "Load reports error:",
            error
        );

        reportsList.innerHTML = `
            <div class="error">
                Unable to connect to server.
            </div>
        `;
    }
}
// ========================================
// SEARCH ITEMS
// ========================================

const searchForm = document.getElementById("searchForm");

if (searchForm) {

    searchForm.addEventListener("submit", async function (event) {

        event.preventDefault();

        const resultsContainer =
            document.getElementById("searchResults");

        const keyword =
            document.getElementById("searchKeyword").value.trim();

        const category =
            document.getElementById("searchCategory").value;

        const location =
            document.getElementById("searchLocation").value;

        const type =
            document.getElementById("searchType").value;


        resultsContainer.innerHTML = `
            <div class="loading">
                Searching...
            </div>
        `;


        try {

            const params = new URLSearchParams();

            params.append("keyword", keyword);
            params.append("category", category);
            params.append("location", location);
            params.append("type", type);


            const response = await fetch(
                `${API_URL}/items/search?${params.toString()}`
            );


            const data = await response.json();


            if (!data.success) {

                resultsContainer.innerHTML = `
                    <div class="error">
                        ${data.message || "Search failed."}
                    </div>
                `;

                return;
            }


            if (data.items.length === 0) {

                resultsContainer.innerHTML = `
                    <div class="empty">
                        No matching items found.
                    </div>
                `;

                return;
            }


            resultsContainer.innerHTML = "";


            data.items.forEach(item => {

                const isLost =
                    item.ItemType === "Lost";


                const typeClass =
                    isLost
                        ? "lost-badge"
                        : "found-badge";


                const icon = isLost ? "&#128230;" : "&#128269;";


                const card =
                    document.createElement("div");


                card.className =
                    "result-card";


                card.innerHTML = `

                    <div class="result-top">

                        <div class="result-title">

                            <span>
                                ${icon}
                            </span>

                            <h3>
                                ${item.ItemName}
                            </h3>

                            <span class="type-badge ${typeClass}">
                                ${item.ItemType}
                            </span>

                        </div>

                        <span class="status-badge">
                            ${item.Status}
                        </span>

                    </div>


                    <div class="result-details">

                        <div>
                            <strong>Category:</strong>
                            ${item.CategoryName}
                        </div>

                        <div>
                            <strong>Location:</strong>
                            ${item.LocationName}
                        </div>

                        <div>
                            <strong>Color:</strong>
                            ${item.Color || "Not specified"}
                        </div>

                        <div>
                            <strong>Brand:</strong>
                            ${item.Brand || "Not specified"}
                        </div>

                        <div>
                            <strong>Date:</strong>
                            ${item.ItemDate}
                        </div>

                    </div>


                    ${
                        item.Description
                            ? `
                            <div class="result-description">
                                <strong>Description:</strong>
                                ${item.Description}
                            </div>
                            `
                            : ""
                    }

                `;

                // Show Claim button only for Found items
                if (!isLost && item.Status === "Found") { 

                    const claimButton = document.createElement("button");

                    claimButton.className = "claim-btn";
                    claimButton.innerHTML = "&#128221; Claim This Item";

                    claimButton.style.marginTop = "15px";
                    claimButton.style.padding = "10px 18px";
                    claimButton.style.border = "none";
                    claimButton.style.borderRadius = "8px";
                    claimButton.style.background = "#2563eb";
                    claimButton.style.color = "white";
                    claimButton.style.fontWeight = "600";
                    claimButton.style.cursor = "pointer";

                    claimButton.addEventListener("click", async function () {

                        const loggedInUser =
                            JSON.parse(
                                localStorage.getItem("loggedInUser") || "null"
                            );

                        if (!loggedInUser) {
                            alert("Please login first to claim this item.");
                            window.location.href = "login.html";
                            return;
                        }

                        const claimDescription = prompt(
                            "Why do you believe this item belongs to you?\n\nPlease provide identifying details:"
                        );

                        if (!claimDescription || !claimDescription.trim()) {
                            alert("Claim description is required.");
                            return;
                        }

                        claimButton.disabled = true;
                        claimButton.innerText = "Submitting...";

                        try {

                            const response = await fetch(
                                `${API_URL}/claims`,
                                {
                                    method: "POST",
                                    headers: {
                                        "Content-Type": "application/json"
                                    },
                                    body: JSON.stringify({
                                        foundItemID: item.ItemID,
                                        userID: loggedInUser.UserID,
                                        claimDescription: claimDescription.trim()
                                    })
                                }
                            );

                            const data = await response.json();

                            if (data.success) {

                                alert(
                                    `Claim submitted successfully!\nClaim ID: ${data.claimID}\nStatus: Pending`
                                );

                                claimButton.innerText = "Claim Submitted";
                                claimButton.disabled = true;

                            } else {

                                alert(
                                    data.message || "Unable to submit claim."
                                );

                                claimButton.disabled = false;
                                claimButton.innerText =
                                    "?? Claim This Item";
                            }

                        } catch (error) {

                            console.error("Claim error:", error);

                            alert(
                                "Unable to connect to server."
                            );

                            claimButton.disabled = false;
                            claimButton.innerText =
                                "?? Claim This Item";
                        }

                    });

                    card.appendChild(claimButton);
                }
                resultsContainer.appendChild(card);

            });


        } catch (error) {

            console.error(
                "Search error:",
                error
            );


            resultsContainer.innerHTML = `
                <div class="error">
                    Unable to connect to server.
                </div>
            `;

        }

    });

}







/* =========================
   MY CLAIMS
========================= */

const claimsResults = document.getElementById("claimsResults");

if (claimsResults) {

    const loggedInUser =
        JSON.parse(
            localStorage.getItem("loggedInUser") || "null"
        );

    if (!loggedInUser) {

        claimsResults.innerHTML = `
            <div class="error">
                Please login to view your claims.
            </div>
        `;

    } else {

        loadMyClaims(loggedInUser.UserID);

    }
}


async function loadMyClaims(userID) {

    try {

        const response = await fetch(
            `${API_URL}/claims?userID=${userID}`
        );

        const data = await response.json();

        if (!data.success) {

            claimsResults.innerHTML = `
                <div class="error">
                    ${data.message || "Unable to load claims."}
                </div>
            `;

            return;
        }


        if (!data.claims || data.claims.length === 0) {

            claimsResults.innerHTML = `
                <div class="empty">
                    You have not submitted any claims yet.
                </div>
            `;

            return;
        }


        claimsResults.innerHTML = "";


        data.claims.forEach(claim => {

            const card = document.createElement("div");

            card.className = "result-card";


            const claimDate =
                new Date(claim.ClaimDate).toLocaleString();


            card.innerHTML = `

                <div class="result-top">

                    <div class="result-title">

                        <span>&#128221;</span>

                        <h3>
                            ${claim.ItemName}
                        </h3>

                    </div>

                    <span class="status-badge">
                        ${claim.Status}
                    </span>

                </div>


                <div class="result-details">

                    <div>
                        <strong>Claim ID:</strong>
                        ${claim.ClaimID}
                    </div>

                    <div>
                        <strong>Category:</strong>
                        ${claim.CategoryName || "Not specified"}
                    </div>

                    <div>
                        <strong>Location:</strong>
                        ${claim.LocationName || "Not specified"}
                    </div>

                    <div>
                        <strong>Color:</strong>
                        ${claim.Color || "Not specified"}
                    </div>

                    <div>
                        <strong>Brand:</strong>
                        ${claim.Brand || "Not specified"}
                    </div>

                    <div>
                        <strong>Claim Date:</strong>
                        ${claimDate}
                    </div>

                </div>


                <div class="result-description">

                    <strong>Your Claim:</strong>
                    ${claim.ClaimDescription}

                </div>

            `;


            claimsResults.appendChild(card);

        });


    } catch (error) {

        console.error("My Claims error:", error);

        claimsResults.innerHTML = `
            <div class="error">
                Unable to connect to server.
            </div>
        `;

    }

}




