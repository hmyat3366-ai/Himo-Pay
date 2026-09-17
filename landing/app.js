// ==========================================================================
// HimoPay Landing Page Interactive Logic
// ==========================================================================

document.addEventListener('DOMContentLoaded', () => {
  // ── 1. Automatic OS Detection ──
  const userAgent = navigator.userAgent || navigator.vendor || window.opera;
  const isAndroid = /android/i.test(userAgent);
  const isIOS = /iPad|iPhone|iPod/.test(userAgent) && !window.MSStream;

  const heroDownloadApk = document.getElementById('hero-download-apk');
  const dlApkBtn = document.getElementById('dl-apk-btn');
  const dlIosBtn = document.getElementById('dl-ios-btn');

  if (isAndroid) {
    if (heroDownloadApk) heroDownloadApk.classList.add('pulse-highlight');
    if (dlApkBtn) dlApkBtn.classList.add('pulse-highlight');
  } else if (isIOS) {
    if (dlIosBtn) dlIosBtn.classList.add('pulse-highlight');
  }

  // ── 2. QR Code Modal Logic ──
  const openQrBtn = document.getElementById('open-qr-modal-btn');
  const qrModal = document.getElementById('qr-modal');
  const modalCloseBtn = document.getElementById('modal-close-btn');

  function openModal() {
    if (qrModal) qrModal.classList.add('open');
    document.body.style.overflow = 'hidden';
  }

  function closeModal() {
    if (qrModal) qrModal.classList.remove('open');
    document.body.style.overflow = '';
  }

  if (openQrBtn) openQrBtn.addEventListener('click', openModal);
  if (modalCloseBtn) modalCloseBtn.addEventListener('click', closeModal);

  if (qrModal) {
    qrModal.addEventListener('click', (e) => {
      if (e.target === qrModal) closeModal();
    });
  }

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && qrModal && qrModal.classList.contains('open')) {
      closeModal();
    }
  });

  // ── 3. FAQ Accordion Interaction ──
  const faqItems = document.querySelectorAll('.faq-item');
  faqItems.forEach(item => {
    const question = item.querySelector('.faq-question');
    if (question) {
      question.addEventListener('click', () => {
        const isActive = item.classList.contains('active');
        // Close others
        faqItems.forEach(other => other.classList.remove('active'));
        if (!isActive) {
          item.classList.add('active');
        }
      });
    }
  });

  // ── 4. Mobile Menu Toggle ──
  const mobileToggle = document.getElementById('mobile-menu-toggle');
  const navLinks = document.getElementById('nav-links');

  if (mobileToggle && navLinks) {
    mobileToggle.addEventListener('click', () => {
      const isShowing = navLinks.style.display === 'flex';
      navLinks.style.display = isShowing ? 'none' : 'flex';
      if (!isShowing) {
        navLinks.style.flexDirection = 'column';
        navLinks.style.position = 'absolute';
        navLinks.style.top = '76px';
        navLinks.style.left = '0';
        navLinks.style.right = '0';
        navLinks.style.background = 'white';
        navLinks.style.padding = '24px';
        navLinks.style.boxShadow = '0 10px 30px rgba(0,0,0,0.1)';
      }
    });
  }

  // ── 5. Download Feedback Toast ──
  const downloadLinks = document.querySelectorAll('a[download]');
  downloadLinks.forEach(link => {
    link.addEventListener('click', () => {
      showDownloadToast('Starting download: HimoPay-release.apk (61.9 MB)...');
    });
  });

  function showDownloadToast(message) {
    let toast = document.getElementById('dl-toast');
    if (!toast) {
      toast = document.createElement('div');
      toast.id = 'dl-toast';
      toast.style.position = 'fixed';
      toast.style.bottom = '30px';
      toast.style.right = '30px';
      toast.style.background = '#0D1117';
      toast.style.color = '#FFFFFF';
      toast.style.padding = '14px 24px';
      toast.style.borderRadius = '999px';
      toast.style.fontSize = '14px';
      toast.style.fontWeight = '700';
      toast.style.boxShadow = '0 12px 36px rgba(0,0,0,0.3)';
      toast.style.zIndex = '9999';
      toast.style.border = '1px solid #21262D';
      toast.style.display = 'flex';
      toast.style.alignItems = 'center';
      toast.style.gap = '10px';
      toast.style.transition = 'all 0.3s ease';
      document.body.appendChild(toast);
    }
    toast.innerHTML = `
      <span style="display:inline-block; width:10px; height:10px; border-radius:50%; background:#FF5E14;"></span>
      <span>${message}</span>
    `;
    toast.style.opacity = '1';
    toast.style.transform = 'translateY(0)';

    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateY(10px)';
    }, 4000);
  }
});
