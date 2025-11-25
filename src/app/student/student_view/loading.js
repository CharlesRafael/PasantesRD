export default function LoadingStudentView() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-[#f5f5f5]">
      <div className="text-center">
        <p className="text-[#407dc3] font-semibold text-lg">
          Cargando perfil de la empresa...
        </p>
        <p className="text-gray-500 text-sm mt-2">
          Por favor, espera un momento.
        </p>
      </div>
    </div>
  );
}
