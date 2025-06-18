/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nb
fs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// Pagination and filtering logic
const rowsPerPage = 10;
let currentPage = 1;
let filteredRows = [];

// Get all rows
const allRows = Array.from(document.querySelectorAll('#userTableBody tr'));

// Initialize pagination
function updatePagination() {
  const totalRows = filteredRows.length || allRows.length;
  const totalPages = Math.ceil(totalRows / rowsPerPage);
  currentPage = Math.max(1, Math.min(currentPage, totalPages));

  // Show/hide rows based on current page
  const start = (currentPage - 1) * rowsPerPage;
  const end = start + rowsPerPage;

  allRows.forEach(row => row.style.display = 'none');
  (filteredRows.length ? filteredRows : allRows).slice(start, end).forEach(row => row.style.display = '');

  // Update pagination info
  document.getElementById('pageInfo').textContent = `Trang ${currentPage} / ${totalPages}`;

  // Enable/disable buttons
  document.getElementById('prevPage').disabled = currentPage === 1;
  document.getElementById('nextPage').disabled = currentPage === totalPages;
}

// Filter logic
document.querySelectorAll('#roleFilter, #statusFilter, #createdDateFilter, #courseFilter, #nameSearch').forEach(filter => {
  filter.addEventListener('change', applyFilters);
  filter.addEventListener('input', applyFilters);
});

function applyFilters() {
  const role = document.getElementById('roleFilter').value.toLowerCase();
  const status = document.getElementById('statusFilter').value.toLowerCase();
  const createdDate = document.getElementById('createdDateFilter').value;
  const courseCount = document.getElementById('courseFilter').value;
  const nameSearch = document.getElementById('nameSearch').value.toLowerCase();

  filteredRows = allRows.filter(row => {
    const roleText = row.cells[5].textContent.toLowerCase();
    const statusText = row.cells[6].textContent.toLowerCase().replace('hoạt động', 'hoạt động').replace('khóa', 'khóa');
    const createdDateText = row.cells[8].textContent;
    const courseText = parseInt(row.cells[7].textContent) || 0;
    const nameText = row.cells[2].textContent.toLowerCase();

    const matchesRole = role === '' || roleText.includes(role);
    const matchesStatus = status === '' || statusText.includes(status);
    const matchesDate = !createdDate || createdDateText === createdDate;
    const matchesCourses = courseCount === '' || courseText >= parseInt(courseCount);
    const matchesName = !nameSearch || nameText.includes(nameSearch);

    return matchesRole && matchesStatus && matchesDate && matchesCourses && matchesName;
  });

  currentPage = 1; // Reset to first page on filter change
  updatePagination();
}

// Pagination button listeners
document.getElementById('prevPage').addEventListener('click', () => {
  if (currentPage > 1) {
    currentPage--;
    updatePagination();
  }
});

document.getElementById('nextPage').addEventListener('click', () => {
  const totalRows = filteredRows.length || allRows.length;
  const totalPages = Math.ceil(totalRows / rowsPerPage);
  if (currentPage < totalPages) {
    currentPage++;
    updatePagination();
  }
});

// View user details modal logic
document.querySelectorAll('.btn-view').forEach(button => {
  button.addEventListener('click', function () {
    const userId = this.getAttribute('data-user-id');
    const fullName = this.getAttribute('data-full-name');
    const username = this.getAttribute('data-username');
    const email = this.getAttribute('data-email');
    const role = this.getAttribute('data-role');
    const status = this.getAttribute('data-status');
    const courses = this.getAttribute('data-courses');
    const createdDate = this.getAttribute('data-created-date');

    document.getElementById('viewUserId').textContent = userId;
    document.getElementById('viewFullName').textContent = fullName;
    document.getElementById('viewUsername').textContent = username;
    document.getElementById('viewEmail').textContent = email;
    document.getElementById('viewRole').textContent = role;
    document.getElementById('viewStatus').innerHTML = status === 'Hoạt Động' 
      ? '<span class="badge badge-active">Hoạt Động</span>' 
      : '<span class="badge badge-inactive">Khóa</span>';
    document.getElementById('viewCourses').textContent = courses;
    document.getElementById('viewCreatedDate').textContent = createdDate;
  });
});

// Edit user modal logic
document.querySelectorAll('.btn-edit').forEach(button => {
  button.addEventListener('click', function () {
    const userId = this.getAttribute('data-user-id');
    const fullName = this.getAttribute('data-full-name');
    const username = this.getAttribute('data-username');
    const email = this.getAttribute('data-email');
    const role = this.getAttribute('data-role');
    const status = this.getAttribute('data-status');

    document.getElementById('editUserId').value = userId;
    document.getElementById('editFullName').value = fullName;
    document.getElementById('editUsername').value = username;
    document.getElementById('editEmail').value = email;
    document.getElementById('editRole').value = role;
    document.getElementById('editStatus').value = status;
    document.getElementById('editPassword').value = ''; // Clear password field
  });
});

// Block user modal logic
document.querySelectorAll('.btn-block').forEach(button => {
  button.addEventListener('click', function () {
    const userId = this.getAttribute('data-user-id');
    const fullName = this.getAttribute('data-full-name');
    const status = this.getAttribute('data-status');
    
    document.getElementById('blockUserId').textContent = userId;
    document.getElementById('blockFullName').textContent = fullName;
    document.getElementById('blockUserIdInput').value = userId;
    document.getElementById('blockStatusInput').value = status === 'Hoạt Động' ? 'Khóa' : 'Hoạt Động';
    document.getElementById('blockAction').textContent = status === 'Hoạt Động' ? 'khóa' : 'mở khóa';
  });
});

// Notification action logic
document.querySelectorAll('.btn-approve, .btn-reject').forEach(button => {
  button.addEventListener('click', function () {
    const notificationId = this.getAttribute('data-notification-id');
    const action = this.classList.contains('btn-approve') ? 'approve' : 'reject';
    
    // Simulate sending request to server
    console.log(`Notification ${notificationId} ${action}ed`);
    
    // Update notification count
    const notificationCount = document.getElementById('notificationCount');
    let count = parseInt(notificationCount.textContent);
    if (count > 0) {
      notificationCount.textContent = count - 1;
    }
    
    // Remove notification item
    this.closest('.notification-item').remove();
    
    // If no notifications left, update UI
    if (!document.querySelector('.notification-item')) {
      document.querySelector('.notification-list').innerHTML = '<p>Không có thông báo nào.</p>';
      notificationCount.style.display = 'none';
    }
  });
});

// Initial pagination setup
updatePagination();