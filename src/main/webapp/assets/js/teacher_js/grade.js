document.addEventListener('DOMContentLoaded', () => {
    // Handle assignment item selection
    const assignmentItems = document.querySelectorAll('.assignment-item');
    assignmentItems.forEach(item => {
        item.addEventListener('click', () => {
            assignmentItems.forEach(i => i.classList.remove('active'));
            item.classList.add('active');
            const assignmentId = item.dataset.assignmentId;
            console.log(`Selected assignment ID: ${assignmentId}`);
            // Placeholder: Fetch questions for this assignment (implement backend logic)
        });
    });

    // Handle question item selection
    const questionItems = document.querySelectorAll('.question-item');
    const selectedQuestionText = document.getElementById('selectedQuestionText');
    const selectedAnswerText = document.getElementById('selectedAnswerText');

    questionItems.forEach(item => {
        item.addEventListener('click', () => {
            questionItems.forEach(q => q.classList.remove('active'));
            item.classList.add('active');
            
            const questionId = item.dataset.questionId;
            const questionText = item.querySelector('.question-text').textContent;
            // Placeholder: Fetch answer and other details for this question (implement backend logic)
            const answerText = `Đáp án cho câu hỏi "${questionText}"`; // Example response

            selectedQuestionText.textContent = questionText;
            selectedAnswerText.textContent = answerText;
        });
    });

    // Handle grading form submission
    const gradingForm = document.getElementById('gradingForm');
    gradingForm.addEventListener('submit', (e) => {
        e.preventDefault();
        const grade = document.getElementById('grade').value;
        const feedback = document.getElementById('feedback').value;
        
        if (grade < 0 || grade > 100) {
            alert('Vui lòng nhập điểm từ 0 đến 100.');
            return;
        }

        // Placeholder: Send grading data to server via AJAX with questionId
        const activeQuestion = document.querySelector('.question-item.active');
        const questionId = activeQuestion ? activeQuestion.dataset.questionId : null;
        console.log('Submitting grade:', { grade, feedback, questionId });
        alert('Điểm và nhận xét đã được gửi!');
        // Example: Reset form or update UI after submission
        // gradingForm.reset();
    });
});

});
