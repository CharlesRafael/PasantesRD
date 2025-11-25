  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    // 1) USUARIO DE PRUEBA: NO USA API NI BASE DE DATOS
    if (email === 'test@mail' && password === '1234') {
      const role = userType; // 'student' o 'company'

      // Estos IDs son de ejemplo:
      // - si entras como estudiante → id 13 (tu "Test Student" en la tabla)
      // - si entras como empresa → id 1 (EDAB Software Developer)
      const fakeId = role === 'student' ? 13 : 1;

      if (typeof window !== 'undefined') {
        const userData = {
          id: fakeId,
          email,
          role,
          isLoggedIn: true,
          loginTime: new Date().toISOString(),
        };

        console.log('🔄 LOGIN DE PRUEBA, GUARDANDO EN LOCALSTORAGE:', userData);

        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('currentUserId', fakeId);
        localStorage.setItem('userEmail', email);
        localStorage.setItem('userRole', role);
      }

      // Redirección según el tipo de usuario
      if (role === 'student') {
        router.push(`/student/profile/${fakeId}`);
      } else {
        router.push(`/company/profile/${fakeId}`);
      }

      return; // MUY IMPORTANTE: no seguimos al axios
    }

    // 2) RESTO DE USUARIOS: sigue usando la API normal (aunque ahora mismo falle por la BD)
    try {
      const response = await axios.post('/api/login', {
        email,
        password,
        role: userType,
      });

      const { exists, role, id } = response.data;

      if (!exists) {
        setError('No estás registrado. Por favor regístrate.');
        return;
      }

      if (typeof window !== 'undefined') {
        const userData = {
          id,
          email,
          role,
          isLoggedIn: true,
          loginTime: new Date().toISOString(),
        };

        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('currentUserId', id);
        localStorage.setItem('userEmail', email);
        localStorage.setItem('userRole', role);
      }

      if (role === 'student') {
        router.push(`/student/profile/${id}`);
      } else {
        router.push(`/company/profile/${id}`);
      }
    } catch (err) {
      console.error('💥 Error en login real (API):', err);
      const errorMessage =
        err.response?.data?.message ||
        'Error al iniciar sesión. Por favor, inténtelo de nuevo.';
      setError(errorMessage);
    }
  };
