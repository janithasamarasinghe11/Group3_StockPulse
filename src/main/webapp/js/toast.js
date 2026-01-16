/**
 * StockPulse Toast Notification System
 * Modern, animated toast notifications
 */

const Toast = {
    container: null,

    init() {
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.className = 'sp-toast-container';
            document.body.appendChild(this.container);
        }
    },

    show(type, title, message, duration = 5000) {
        this.init();

        const toast = document.createElement('div');
        toast.className = `sp-toast ${type}`;

        const icons = {
            success: 'bi-check-circle-fill',
            error: 'bi-x-circle-fill',
            warning: 'bi-exclamation-triangle-fill',
            info: 'bi-info-circle-fill'
        };

        toast.innerHTML = `
            <div class="sp-toast-icon">
                <i class="bi ${icons[type] || icons.info}"></i>
            </div>
            <div class="sp-toast-content">
                <div class="sp-toast-title">${title}</div>
                <div class="sp-toast-message">${message}</div>
            </div>
            <button class="sp-toast-close" onclick="Toast.close(this.parentElement)">
                <i class="bi bi-x"></i>
            </button>
        `;

        this.container.appendChild(toast);

        // Auto-close
        if (duration > 0) {
            setTimeout(() => this.close(toast), duration);
        }

        return toast;
    },

    close(toast) {
        if (!toast || toast.classList.contains('hiding')) return;
        toast.classList.add('hiding');
        setTimeout(() => {
            if (toast.parentElement) {
                toast.parentElement.removeChild(toast);
            }
        }, 300);
    },

    success(message, title = 'Success') {
        return this.show('success', title, message);
    },

    error(message, title = 'Error') {
        return this.show('error', title, message);
    },

    warning(message, title = 'Warning') {
        return this.show('warning', title, message);
    },

    info(message, title = 'Info') {
        return this.show('info', title, message);
    }
};

/**
 * Form Validation Helper
 */
const FormValidator = {
    validate(form) {
        let isValid = true;
        const inputs = form.querySelectorAll('[required]');

        inputs.forEach(input => {
            this.clearError(input);

            if (!input.value.trim()) {
                this.showError(input, 'This field is required');
                isValid = false;
            } else if (input.type === 'email' && !this.isValidEmail(input.value)) {
                this.showError(input, 'Please enter a valid email');
                isValid = false;
            } else if (input.type === 'number' && input.min && parseFloat(input.value) < parseFloat(input.min)) {
                this.showError(input, `Value must be at least ${input.min}`);
                isValid = false;
            } else {
                input.classList.add('is-valid');
            }
        });

        return isValid;
    },

    showError(input, message) {
        input.classList.add('is-invalid');
        input.classList.remove('is-valid');

        let feedback = input.parentElement.querySelector('.invalid-feedback');
        if (!feedback) {
            feedback = document.createElement('div');
            feedback.className = 'invalid-feedback';
            input.parentElement.appendChild(feedback);
        }
        feedback.textContent = message;
    },

    clearError(input) {
        input.classList.remove('is-invalid', 'is-valid');
        const feedback = input.parentElement.querySelector('.invalid-feedback');
        if (feedback) feedback.remove();
    },

    isValidEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }
};

/**
 * Loading Button Helper
 */
const LoadingButton = {
    start(button) {
        button.dataset.originalText = button.innerHTML;
        button.classList.add('btn-loading');
        button.disabled = true;
    },

    stop(button) {
        button.classList.remove('btn-loading');
        button.innerHTML = button.dataset.originalText;
        button.disabled = false;
    }
};

/**
 * Initialize on page load
 */
document.addEventListener('DOMContentLoaded', function () {
    Toast.init();

    // Check for URL message parameters and show toast
    const params = new URLSearchParams(window.location.search);
    const message = params.get('message');
    const messageType = params.get('messageType');

    if (message) {
        setTimeout(() => {
            if (messageType === 'success') {
                Toast.success(decodeURIComponent(message));
            } else if (messageType === 'danger' || messageType === 'error') {
                Toast.error(decodeURIComponent(message));
            } else if (messageType === 'warning') {
                Toast.warning(decodeURIComponent(message));
            } else {
                Toast.info(decodeURIComponent(message));
            }
        }, 300);
    }

    // Add ripple effect to buttons
    document.querySelectorAll('.btn-primary-custom, .btn-outline-custom').forEach(btn => {
        btn.classList.add('ripple');
    });
});
