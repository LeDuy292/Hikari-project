// Sample cart data
let cart = [
    {
        title: "Tài liệu",
        instructor: "abcxyz",
        price: 20,
        image: "img/course.jpg"
    },
    {
        title: "Modal verbs",
        instructor: "abcxyz",
        price: 20,
        image: "img/img_student/course.jpg"
    }
];

// Sample discount codes
const discountCodes = {
    "SAVE10": 0.1, // 10% discount
    "SAVE20": 0.2, // 20% discount
    "HIKARI50": 0.5 // 50% discount
};

let appliedDiscount = 0;

// Function to create cart item HTML
function createCartItem(item, index) {
    return `
        <div class="flex items-center py-4">
            <img src="${item.image}" alt="${item.title}" class="w-16 h-16 object-cover rounded-lg mr-4">
            <div class="flex-1">
                <h3 class="font-semibold text-lg">${item.title}</h3>
                <p class="text-gray-500 text-sm">Giảng viên: ${item.instructor}</p>
            </div>
            <div class="text-lg font-semibold text-gray-800">$${item.price}</div>
            <button class="ml-4 text-orange-500 hover:text-orange-600 transition" onclick="removeFromCart(${index})">
                <i class="fa fa-trash"></i>
            </button>
        </div>
    `;
}

// Function to display cart items and update total
function displayCart() {
    const cartList = document.getElementById('cartList');
    const cartEmpty = document.getElementById('cartEmpty');
    const cartTotal = document.getElementById('cartTotal');
    const checkoutBtn = document.getElementById('checkoutBtn');

    if (cart.length === 0) {
        cartList.classList.add('hidden');
        cartEmpty.classList.remove('hidden');
        checkoutBtn.disabled = true;
    } else {
        cartList.classList.remove('hidden');
        cartEmpty.classList.add('hidden');
        checkoutBtn.disabled = false;
        cartList.innerHTML = cart.map((item, index) => createCartItem(item, index)).join('');
    }

    const subtotal = cart.reduce((sum, item) => sum + item.price, 0);
    const discountAmount = subtotal * appliedDiscount;
    const total = subtotal - discountAmount;
    cartTotal.textContent = `$${total.toFixed(2)}`;
}

// Function to remove item from cart
function removeFromCart(index) {
    cart.splice(index, 1);
    displayCart();
}

// Function to apply discount code
function applyDiscountCode() {
    const discountCodeInput = document.getElementById('discountCode');
    const discountMessage = document.getElementById('discountMessage');
    const code = discountCodeInput.value.trim().toUpperCase();

    if (code && discountCodes[code]) {
        appliedDiscount = discountCodes[code];
        discountMessage.classList.remove('hidden', 'text-red-500');
        discountMessage.classList.add('text-green-500');
        discountMessage.textContent = `Mã giảm giá ${code} đã được áp dụng! Giảm ${appliedDiscount * 100}%`;
    } else {
        appliedDiscount = 0;
        discountMessage.classList.remove('hidden', 'text-green-500');
        discountMessage.classList.add('text-red-500');
        discountMessage.textContent = 'Mã giảm giá không hợp lệ';
    }

    displayCart();
}

// Modal control functions
function openModal() {
    document.getElementById('signupModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('signupModal').style.display = 'none';
}

// Event listeners
document.addEventListener('DOMContentLoaded', () => {
    displayCart();

    const applyDiscountBtn = document.getElementById('applyDiscount');
    if (applyDiscountBtn) {
        applyDiscountBtn.addEventListener('click', applyDiscountCode);
    }

    const checkoutBtn = document.getElementById('checkoutBtn');
    if (checkoutBtn) {
        checkoutBtn.addEventListener('click', () => {
            alert('Thanh toán thành công!');
            window.location.href = 'ketqua.jsp'; // Redirect to ketqua.jsp
        });
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('signupModal');
        if (event.target === modal) {
            closeModal();
        }
    };
});