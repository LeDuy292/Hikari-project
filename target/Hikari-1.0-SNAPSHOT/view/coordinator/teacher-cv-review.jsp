<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher CV Review - Coordinator Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/coordinator_css/teacher-cv-review.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
                             <jsp:include page="sidebarCoordinator.jsp" />

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
            <jsp:include page="headerCoordinator.jsp" />
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Teacher CV Review</h1>
                </div>

                <!-- Search and Filter Section -->
                <div class="row mb-4 search-filter-section">
                    <div class="col-md-6">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Search by name or specialization...">
                            <button class="btn btn-primary" type="button">
                                <i class="fas fa-search"></i> Search
                            </button>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex justify-content-end">
                            <select class="form-select me-2" style="width: auto;">
                                <option value="">All Status</option>
                                <option value="pending">Pending</option>
                                <option value="approved">Approved</option>
                                <option value="rejected">Rejected</option>
                            </select>
                            <select class="form-select" style="width: auto;">
                                <option value="">All Specializations</option>
                                <option value="math">Mathematics</option>
                                <option value="science">Science</option>
                                <option value="english">English</option>
                                <option value="history">History</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Loading Spinner -->
                <div class="loading-spinner">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>

                <!-- CV List -->
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Specialization</th>
                                <th>Experience</th>
                                <th>Education</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>John Doe</td>
                                <td>Mathematics</td>
                                <td>5 years</td>
                                <td>MSc in Mathematics</td>
                                <td><span class="badge bg-warning">Pending</span></td>
                                <td>
                                    <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#viewCVModal">
                                        <i class="fas fa-eye"></i> View
                                    </button>
                                    <button class="btn btn-sm btn-success">
                                        <i class="fas fa-check"></i> Approve
                                    </button>
                                    <button class="btn btn-sm btn-danger">
                                        <i class="fas fa-times"></i> Reject
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item disabled">
                            <a class="page-link" href="#" tabindex="-1">Previous</a>
                        </li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#">Next</a>
                        </li>
                    </ul>
                </nav>
            </main>
        </div>
    </div>

    <!-- View CV Modal -->
    <div class="modal fade" id="viewCVModal" tabindex="-1" aria-labelledby="viewCVModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewCVModalLabel">Teacher CV Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4">
                            <img src="assets/default-avatar.png" class="img-fluid rounded profile-image" alt="Profile Picture">
                        </div>
                        <div class="col-md-8">
                            <h4>John Doe</h4>
                            <p class="text-muted">Mathematics Teacher</p>
                            <hr>
                            <div class="cv-section">
                                <h5>Personal Information</h5>
                                <p><strong>Email:</strong> john.doe@example.com</p>
                                <p><strong>Phone:</strong> +1234567890</p>
                                <p><strong>Location:</strong> New York, USA</p>
                            </div>
                        </div>
                    </div>
                    <hr>
                    <div class="cv-section">
                        <h5>Education</h5>
                        <ul>
                            <li>MSc in Mathematics - University of Example (2018-2020)</li>
                            <li>BSc in Mathematics - University of Example (2014-2018)</li>
                        </ul>
                    </div>
                    <div class="cv-section">
                        <h5>Work Experience</h5>
                        <ul>
                            <li>Mathematics Teacher - High School XYZ (2020-Present)</li>
                            <li>Teaching Assistant - University of Example (2018-2020)</li>
                        </ul>
                    </div>
                    <div class="cv-section">
                        <h5>Skills</h5>
                        <div class="mb-3">
                            <span class="skills-badge">Advanced Mathematics</span>
                            <span class="skills-badge">Curriculum Development</span>
                            <span class="skills-badge">Student Assessment</span>
                            <span class="skills-badge">Classroom Management</span>
                        </div>
                    </div>
                    <div class="cv-section">
                        <h5>CV Document</h5>
                        <div class="cv-preview">
                            <embed src="path/to/cv.pdf" type="application/pdf" width="100%" height="500px">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-success">Approve</button>
                    <button type="button" class="btn btn-danger">Reject</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="static/js/main.js"></script>
</body>
</html> 