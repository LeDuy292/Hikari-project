function checkSession() {
    fetch('/Hikari_Plus/checkSession', {
        method: 'GET',
        credentials: 'same-origin'
    })
    .then(response => response.json())
    .then(data => {
        if (data.valid === false) {
            // Đăng xuất ngay lập tức khi nhận false
            alert('Phiên làm việc đã hết hạn do đăng nhập từ thiết bị khác. Vui lòng đăng nhập lại.');
            window.location.href = '/Hikari_Plus/view/login.jsp';
        }
    })
    .catch(error => console.error('Error checking session:', error));
}

// Kiểm tra mỗi 2.5 giây
setInterval(checkSession, 90000000);